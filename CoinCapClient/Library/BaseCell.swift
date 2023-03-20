import Foundation
import UIKit

class BaseCollectionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) unavailable")
    }

    /// Default implementation does nothing
    /// Called once during initialization
    func setupLayout() {
        accessoryType = .disclosureIndicator
    }
}
