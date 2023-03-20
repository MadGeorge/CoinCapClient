import Foundation
import UIKit
import DiffableDataSources

extension Settings {
    final class SnapshotBuilder {
        private weak var snapshotProvider: ISettingsSnapshotProvider?
        private var snapshot: Snapshot?

        private func getOrCreateSnapshot() -> Snapshot {
            if snapshot == nil { snapshot = snapshotProvider?.snapshot ?? .init() }
            return snapshot ?? .init()
        }

        init(snapshotProvider: ISettingsSnapshotProvider) {
            self.snapshotProvider = snapshotProvider
        }

        @discardableResult
        func addSettings(current: String) -> Self {
            var snapshot = getOrCreateSnapshot()

            if snapshot.indexOfSection(.icon) == nil {
                snapshot.appendSections([.icon])
            }

            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: .icon))
            snapshot.appendItems([.icon(current)], toSection: .icon)

            self.snapshot = snapshot

            return self
        }

        @discardableResult
        func addWatchlist() -> Self {
            removeWatchlist()
            var snapshot = getOrCreateSnapshot()

            if snapshot.indexOfSection(.watchlist) == nil {
                snapshot.appendSections([.watchlist])
            }

            snapshot.appendItems([.clearWatchlist], toSection: .watchlist)

            self.snapshot = snapshot

            return self
        }

        @discardableResult
        func removeWatchlist() -> Self {
            var snapshot = getOrCreateSnapshot()

            snapshot.deleteItems(snapshot.itemIdentifiers.filter { $0 == .clearWatchlist })
            self.snapshot = snapshot

            return self
        }

        func build() -> Snapshot {
            snapshot ?? .init()
        }
    }
}
