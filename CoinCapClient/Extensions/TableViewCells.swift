import Foundation
import UIKit

@objc protocol SelfIdentifiable: AnyObject {
    static var selfIdentifier: String { get }
}

extension UITableViewCell: SelfIdentifiable {
    class var selfIdentifier: String {
        String(describing: self)
    }
}

extension UITableViewHeaderFooterView: SelfIdentifiable {
    class var selfIdentifier: String {
        String(describing: self)
    }
}

extension UITableView {
    func registerCell(_ cellType: SelfIdentifiable.Type) {
        register(cellType, forCellReuseIdentifier: cellType.selfIdentifier)
    }

    func dequeueCell<T: SelfIdentifiable>(_ cellType: T.Type) -> T? {
        dequeueReusableCell(withIdentifier: cellType.selfIdentifier) as? T
    }

    func dequeueCell<T: SelfIdentifiable>(_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: cellType.selfIdentifier, for: indexPath) as? T
    }

    func registerHeader(_ headerType: SelfIdentifiable.Type) {
        register(headerType.self, forHeaderFooterViewReuseIdentifier: headerType.selfIdentifier)
    }

    func dequeueHeader<T: SelfIdentifiable>(_ headerType: T.Type) -> T? {
        dequeueReusableHeaderFooterView(withIdentifier: headerType.selfIdentifier) as? T
    }
}
