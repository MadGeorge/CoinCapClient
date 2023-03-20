import Foundation
import UIKit
import DiffableDataSources

extension Settings {
    final class Adapter: NSObject {
        private(set) var dataSource: SwipeTableViewDiffableDataSource<Settings.Section, Settings.SectionItem>?

        func adapt(_ table: UITableView) {
            registerCells(in: table)

            dataSource = .init(tableView: table, cellProvider: { table, indexPath, sectionItem in
                switch sectionItem {
                case let .icon(current):
                    return CellAdapter
                        .adaptSettings(table.dequeueCell(ValueCell.self, for: indexPath), current: current)

                case .clearWatchlist:
                    return CellAdapter.adaptButton(table.dequeueCell(ButtonCell.self, for: indexPath))
                }
            })

            dataSource?.sectionTitle = [
                Section.icon.rawValue: L10n.general,
                Section.watchlist.rawValue: L10n.watching
            ]
        }

        func registerCells(in table: UITableView) {
            table.registerCell(ValueCell.self)
            table.registerCell(ButtonCell.self)
        }

        func apply(_ snapshot: Snapshot) {
            dataSource?.apply(snapshot, animatingDifferences: dataSource?.snapshot().numberOfSections != .zero)
        }
    }
}

extension Settings.Adapter: ISettingsSnapshotProvider {
    var snapshot: Settings.Snapshot? {
        dataSource?.snapshot()
    }
}

extension Settings {
    enum CellAdapter {
        static func adaptSettings(_ cell: ValueCell?, current: String) -> UITableViewCell? {
            cell?.textLabel?.text = L10n.icon
            cell?.detailTextLabel?.text = current
            cell?.accessoryType = .disclosureIndicator
            return cell
        }

        static func adaptButton(_ cell: ButtonCell?) -> UITableViewCell? {
            cell?.textLabel?.text = L10n.delete
            cell?.accessibilityLabel = UITests.Identifiers.clearWatched
            return cell
        }
    }
}
