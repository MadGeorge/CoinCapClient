import Foundation
import UIKit
import XCoordinator

enum AssetsRoute: Route {
    case list, details(Model.Asset)
}

final class AssetsCoordinator: NavigationCoordinator<AssetsRoute> {
    let mode: Assets.Mode

    init (mode: Assets.Mode) {
        self.mode = mode

        super.init(initialRoute: .list)
    }

    override func prepareTransition(for route: AssetsRoute) -> NavigationTransition {
        switch route {
        case .list:
            return .push(Assets.build(router: unownedRouter, mode: mode))

        case let .details(asset):
            return .push(AssetDetails.build(asset: asset, router: unownedRouter))
        }
    }
}
