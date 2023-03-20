import Foundation
import UIKit
import DiffableDataSources

extension Assets {
    final class SnapshotBuilder {
        private weak var snapshotProvider: IAssetsSnapshotProvider?
        private var snapshot: Snapshot?

        private func getOrCreateSnapshot() -> Snapshot {
            if snapshot == nil { snapshot = snapshotProvider?.snapshot ?? .init() }
            return snapshot ?? .init()
        }

        init(snapshotProvider: IAssetsSnapshotProvider) {
            self.snapshotProvider = snapshotProvider

            var snapshot = getOrCreateSnapshot()

            if snapshot.numberOfSections == .zero {
                snapshot.appendSections([.main])
            }

            snapshot.appendItems([.activityIndicator])

            self.snapshot = snapshot
        }

        @discardableResult
        func add(_ assets: [Model.Asset], replace: Bool) -> Self {
            var snapshot = getOrCreateSnapshot()

            var toRemove = [SectionItem]()
            for asset in assets {
                toRemove.append(contentsOf: snapshot.itemIdentifiers.filter { item in
                    switch item {
                    case .activityIndicator:
                        return false

                    case let .asset(itemAsset):
                        if replace { return true }
                        return itemAsset == asset
                    }
                })
            }
            snapshot.deleteItems(toRemove)
            snapshot.appendItems(assets.map { .asset($0) }, toSection: .main)

            self.snapshot = snapshot

            return self
        }

        func build() -> Snapshot {
            if var snapshot {
                if let last = snapshot.itemIdentifiers.last, last != .activityIndicator {
                    snapshot.moveItem(.activityIndicator, afterItem: last)
                }

                self.snapshot = snapshot
            }

            return getOrCreateSnapshot()
        }
    }
}
