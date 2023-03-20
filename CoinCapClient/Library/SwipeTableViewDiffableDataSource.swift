import Foundation
import UIKit
import DiffableDataSources

class SwipeTableViewDiffableDataSource<S: Hashable, I: Hashable>: TableViewDiffableDataSource<S, I> {
    var sectionTitle = [Int: String]()

    override func tableView(_ tableView: UITableView, canEditRowAt: IndexPath) -> Bool {
        true
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionTitle[section]
    }
}
