import Foundation
import UIKit
import Resolver
import OpenCombine
import XCoordinator

extension Settings {
    final class ViewModel: ISettingsVM {
        @Injected var storage: IStorageService
        @Injected var iconChanger: IChangeIconService

        var viewEvents = PassthroughSubject<Settings.ViewEvent, Never>()
        private(set) var viewState = PassthroughSubject<Settings.ViewState, Never>()

        private let router: UnownedRouter<SettingsRoute>
        private let snapshotBuilder: SnapshotBuilder
        private var currentPage = Int.zero

        init(snapshotProvider: ISettingsSnapshotProvider, router: UnownedRouter<SettingsRoute>) {
            self.snapshotBuilder = .init(snapshotProvider: snapshotProvider)
            self.router = router

            bind()
        }
    }
}

// MARK: - Private

private extension Settings.ViewModel {
    func reloadData() {
        snapshotBuilder.addSettings(current: iconChanger.currentIcon.title)

        if storage.watching.isEmpty {
            snapshotBuilder.removeWatchlist()
        } else {
            snapshotBuilder.addWatchlist()
        }

        viewState.send(.data(snapshotBuilder.build()))
    }

    func openOptions() {
        let options = Model.AppIcon.allCases.map {
            Settings.IconOption(title: $0.title, value: $0, isSelected: $0 == iconChanger.currentIcon)
        }

        self.router.trigger(.icons(options, { [weak self] selected in
            if self?.iconChanger.currentIcon == selected.value { return }

            self?.iconChanger.set(selected.value) { error in
                error.ifLet {
                    self?.viewState.send(.alert(L10n.alertErrorTitle, $0.localizedDescription))
                }
            }
        }))
    }

    func bind() {
        viewEvents.subscribe(Subscribers.Sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] event in
                switch event {
                case .willAppear:
                    self?.reloadData()

                case let .didSelect(sectionItem):
                    switch sectionItem {
                    case .icon:
                        if self?.iconChanger.supportsAlternateIcons != true {
                            self?.viewState.send(.alert(L10n.alertErrorTitle, L10n.altIconError))
                            return
                        }

                        self?.openOptions()

                    case .clearWatchlist:
                        self?.storage.clearWatched()
                        self?.reloadData()
                        self?.viewState.send(.alert(L10n.watchedClearedTitle, L10n.watchedClearedBody))
                    }
                }
            }
        ))
    }
}
