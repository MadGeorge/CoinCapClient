import Foundation
import UIKit
import XCoordinator
import Resolver

enum SettingsRoute: Route {
    case list
    case icons([Settings.IconOption], (Settings.IconOption) -> Void)
}

final class SettingsCoordinator: NavigationCoordinator<SettingsRoute> {
    @Injected var storage: IStorageService

    init () {
        super.init(initialRoute: .list)
    }

    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {
        case .list:
            return .push(Settings.build(router: unownedRouter))

        case let .icons(options, callback):
            let vc = OptionsVC(options: options, title: L10n.icon)
            vc.didSelect = callback

            return .push(vc)
        }
    }
}
