import Foundation
import UIKit
import DiffableDataSources

extension AssetDetails {
    final class Adapter: NSObject {
        private(set) var dataSource: SwipeTableViewDiffableDataSource<AssetDetails.Section, AssetDetails.SectionItem>?

        func adapt(_ table: UITableView) {
            registerCells(in: table)

            dataSource = .init(tableView: table, cellProvider: { table, indexPath, sectionItem in
                switch sectionItem {
                case let .header(title, subtitle):
                    return table.dequeueCell(HeaderCell.self, for: indexPath)?
                        .configure(title: title, subtitle: subtitle)

                case let .row(title, subtitle):
                    return CellAdapter.adaptRow(
                        table.dequeueCell(ValueCell.self, for: indexPath),
                        title: title,
                        subtitle: subtitle
                    )
                }
            })
        }

        func registerCells(in table: UITableView) {
            table.registerCell(HeaderCell.self)
            table.registerCell(ValueCell.self)
        }

        func apply(_ snapshot: Snapshot) {
            dataSource?.apply(snapshot, animatingDifferences: dataSource?.snapshot().numberOfSections != .zero)
        }
    }
}

extension AssetDetails.Adapter: IAssetDetailsSnapshotProvider {
    var snapshot: AssetDetails.Snapshot? {
        dataSource?.snapshot()
    }
}

extension AssetDetails {
    enum CellAdapter {
        static func adaptRow(_ cell: ValueCell?, title: String, subtitle: String) -> UITableViewCell? {
            cell?.textLabel?.text = title
            cell?.detailTextLabel?.text = subtitle
            cell?.selectionStyle = .none
            return cell
        }
    }
}
