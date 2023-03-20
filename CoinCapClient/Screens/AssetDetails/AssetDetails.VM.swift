import Foundation
import UIKit
import Resolver
import OpenCombine
import XCoordinator

extension AssetDetails {
    final class ViewModel: IAssetDetailsVM {
        @Injected var remote: IRemoteService
        @Injected var storage: IStorageService

        var viewEvents = PassthroughSubject<AssetDetails.ViewEvent, Never>()
        private(set) var viewState = PassthroughSubject<AssetDetails.ViewState, Never>()

        private let router: UnownedRouter<AssetsRoute>
        private let snapshotBuilder: SnapshotBuilder
        private let asset: Model.Asset

        init(
            asset: Model.Asset,
            snapshotProvider: IAssetDetailsSnapshotProvider,
            router: XCoordinator.UnownedRouter<AssetsRoute>
        ) {
            self.snapshotBuilder = .init(snapshotProvider: snapshotProvider)
            self.router = router
            self.asset = asset

            bind()
        }
    }
}

// MARK: - Private

private extension AssetDetails.ViewModel {
    func bind() {
        viewEvents.subscribe(Subscribers.Sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] event in
                guard let self else { return }

                switch event {
                case .willAppear:
                    self.viewState.send(.title(self.asset.name, self.asset.symbol))
                    self.viewState.send(.watching(self.storage.watching.contains(self.asset)))
                    self.load(force: false)

                case .didSelect:
                    break

                case .didSelectRightBarButton:
                    self.viewState.send(.watching(self.storage.toggle(self.asset)))
                }
            }
        ))
    }

    func load(force: Bool) {
        snapshotBuilder.addHeader(
            title: DataFormatter.usd(asset.priceUsd.emptyIfNil),
            subtitle: DataFormatter.percent(asset.changePercent24Hr.emptyIfNil)
        )

        if let value = asset.marketCapUsd.nilIfEmpty {
            snapshotBuilder.add(title: L10n.assetCap, value: DataFormatter.usd(value))
        }

        if let value = asset.supply.nilIfEmpty {
            snapshotBuilder.add(title: L10n.assetSupply, value: DataFormatter.usd(value))
        }

        if let value = asset.volumeUsd24Hr.nilIfEmpty {
            snapshotBuilder.add(title: L10n.assetVolume, value: DataFormatter.usd(value))
        }

        viewState.send(.data(snapshotBuilder.build()))

        remote.history(id: asset.id).subscribe(Subscribers.Sink(
            receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.viewState.send(.error(L10n.alertErrorTitle, error.localizedDescription))
                }
            },
            receiveValue: { [weak self] history in
                self?.viewState.send(.chart(history))
            }
        ))
    }
}
