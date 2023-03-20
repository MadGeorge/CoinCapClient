import Foundation
import UIKit
import DiffableDataSources

extension Assets {
    final class Adapter: NSObject {
        private(set) var dataSource: SwipeTableViewDiffableDataSource<Assets.Section, Assets.SectionItem>?

        func adapt(_ table: UITableView) {
            registerCells(in: table)

            dataSource = .init(tableView: table, cellProvider: { table, indexPath, sectionItem in
                switch sectionItem {
                case let .asset(asset):
                    return CellAdapter.adapt(table.dequeueCell(AssetCell.self, for: indexPath), data: asset)

                case .activityIndicator:
                    return table.dequeueCell(LoadingCell.self, for: indexPath)
                }
            })
        }

        func registerCells(in table: UITableView) {
            table.registerCell(AssetCell.self)
            table.registerCell(LoadingCell.self)
        }

        func apply(_ snapshot: Snapshot, complete: @escaping VoidBlock) {
            dataSource?.apply(
                snapshot,
                animatingDifferences: dataSource?.snapshot().numberOfSections != .zero,
                completion: complete
            )
        }
    }
}

extension Assets.Adapter: IAssetsSnapshotProvider {
    var snapshot: Assets.Snapshot? {
        dataSource?.snapshot()
    }
}

extension Assets {
    enum CellAdapter {
        static func adapt(_ cell: AssetCell?, data: Model.Asset) -> AssetCell? {
            cell?.configure(
                image: URL(string: "https://cryptoicons.org/api/color/\(data.symbol.lowercased())/120/c7c7cc"),
                symbol: data.symbol,
                name: data.name,
                cost: DataFormatter.usd(data.priceUsd.emptyIfNil),
                change: DataFormatter.percent(data.changePercent24Hr.emptyIfNil)
            )
        }
    }
}
