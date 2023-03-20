import Foundation
import UIKit

protocol IChangeIconService {
    var supportsAlternateIcons: Bool { get }
    var currentIcon: Model.AppIcon { get }

    func set(_ icon: Model.AppIcon, block: ErrorBlock?)
}

final class ChangeIconService: IChangeIconService {
    var supportsAlternateIcons: Bool {
        UIApplication.shared.supportsAlternateIcons
    }

    var currentIcon: Model.AppIcon {
        .init(id: UIApplication.shared.alternateIconName.emptyIfNil)
    }

    func set(_ icon: Model.AppIcon, block: ErrorBlock?) {
        UIApplication.shared.setAlternateIconName(icon.identifier, completionHandler: block)
    }
}
