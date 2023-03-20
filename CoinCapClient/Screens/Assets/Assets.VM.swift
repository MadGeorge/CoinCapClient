import Foundation
import UIKit
import Resolver
import OpenCombine
import XCoordinator
import OrderedCollections

extension Assets {
    final class ViewModel: IAssetsVM {
        @Injected var remote: IRemoteService
        @Injected var storage: IStorageService

        let searchEvents = PassthroughSubject<String, Never>()
        let viewEvents = PassthroughSubject<Assets.ViewEvent, Never>()
        let viewState = PassthroughSubject<Assets.ViewState, Never>()
        let router: UnownedRouter<AssetsRoute>

        private var nextPageLocker = Locker()
        private let snapshotBuilder: SnapshotBuilder
        private let pageSize = 10
        private var currentOffset = Int.zero
        private let mode: Assets.Mode

        init(snapshotProvider: IAssetsSnapshotProvider, router: UnownedRouter<AssetsRoute>, mode: Assets.Mode) {
            self.snapshotBuilder = .init(snapshotProvider: snapshotProvider)
            self.router = router
            self.mode = mode

            bindViewEvents()
            bindSearchEvent()
        }
    }
}

// MARK: - Private

private extension Assets.ViewModel {
    func bindViewEvents() {
        viewEvents.subscribe(Subscribers.Sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] event in
                guard let self else { return }

                switch event {
                case .didAppear:
                    if self.mode == .favorite || self.currentOffset == .zero {
                        self.load(force: false)
                    }

                case .didRefresh:
                    self.currentOffset = .zero
                    self.load(force: true)

                case let .didSelect(sectionItem):
                    if case let .asset(asset) = sectionItem {
                        self.router.trigger(.details(asset))
                    }

                case let .didSwipe(sectionItem):
                    self.didSwipe(sectionItem)

                case .didReachPageBottom:
                    if self.nextPageLocker.passedThroughOnce() { return }
                    self.currentOffset += self.pageSize
                    self.load(force: false)

                case .didReloadSnapshot:
                    self.nextPageLocker.unlock()
                }
            }
        ))
    }

    func bindSearchEvent() {
        if mode == .search {
            searchEvents
                .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main.ocombine)
                .compactMap { $0.isEmpty ? nil : $0 }
                .flatMap { self.remote.search(text: $0) }
                .replaceError(with: [])
                .subscribe(Subscribers.Sink(
                    receiveCompletion: { _ in },
                    receiveValue: { [weak self] assets in
                        (self?.snapshotBuilder.add(assets, replace: true).build()).ifLet {
                            self?.viewState.send(.data($0))
                        }
                    }
                ))
        }
    }

    func didSwipe(_ item: Assets.SectionItem) {
        guard case let .asset(asset) = item else { return }

        switch self.mode {
        case .favorite:
            self.storage.unWatch(asset)
            asyncOnMain(after: 0.5) {
                self.load(force: false)
            }

        case .list, .search:
            self.storage.watch(asset)
        }
    }

    func load(force: Bool) {
        viewState.send(.loading)

        let publisher: AnyPublisher<[Model.Asset], Error>
        switch mode {
        case .list:
            publisher = remote.fetch(limit: pageSize, offset: currentOffset, force: force)

        case .favorite:
            if storage.watching.isEmpty {
                viewState.send(.placeholder)
                return
            }
            publisher = remote.fetch(ids: storage.watching.map { $0.id }, force: force)

        case .search:
            publisher = Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
        }

        publisher.subscribe(Subscribers.Sink(
            receiveCompletion: { [weak self] completion in
                guard let self else { return }

                if case let .failure(error) = completion {
                    self.viewState.send(.error(L10n.alertErrorTitle, error.localizedDescription))
                    self.currentOffset -= self.pageSize
                }
            },
            receiveValue: { [weak self] assets in
                guard let self else { return }
                let snap = self.snapshotBuilder.add(assets, replace: self.currentOffset == .zero).build()
                self.viewState.send(.data(snap))
            }
        ))
    }
}
