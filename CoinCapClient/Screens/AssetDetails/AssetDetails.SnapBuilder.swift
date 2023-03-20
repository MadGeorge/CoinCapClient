import Foundation
import UIKit
import DiffableDataSources

extension AssetDetails {
    final class SnapshotBuilder {
        private weak var snapshotProvider: IAssetDetailsSnapshotProvider?
        private var snapshot: Snapshot?

        private func getOrCreateSnapshot() -> Snapshot {
            if snapshot == nil { snapshot = snapshotProvider?.snapshot ?? .init() }
            return snapshot ?? .init()
        }

        init(snapshotProvider: IAssetDetailsSnapshotProvider) {
            self.snapshotProvider = snapshotProvider
        }

        @discardableResult
        func addHeader(title: String, subtitle: String) -> Self {
            var snapshot = getOrCreateSnapshot()

            if snapshot.numberOfSections == .zero {
                snapshot.appendSections([.main])
            }

            snapshot.deleteItems(snapshot.itemIdentifiers.filter { item in
                if case .header = item { return true }
                return false
            })

            snapshot.appendItems([.header(title, subtitle)], toSection: .main)

            self.snapshot = snapshot

            return self
        }

        @discardableResult
        func add(title: String, value: String) -> Self {
            var snapshot = getOrCreateSnapshot()

            if snapshot.numberOfSections == .zero {
                snapshot.appendSections([.main])
            }

            snapshot.deleteItems(snapshot.itemIdentifiers.filter { item in
                if case let .row(itemTitle, _) = item, itemTitle == title { return true }
                return false
            })

            snapshot.appendItems([.row(title, value)], toSection: .main)

            self.snapshot = snapshot

            return self
        }

        func build() -> Snapshot {
            snapshot ?? .init()
        }
    }
}
