import Foundation
import UIKit
import XCoordinator

enum RootRoute: Route {
    case assets, watchlist, settings
}

final class RootCoordinator: TabBarCoordinator<RootRoute> {
    private let assets: StrongRouter<AssetsRoute>
    private let watchlist: StrongRouter<AssetsRoute>
    private let settings: StrongRouter<SettingsRoute>

    convenience init() {
        self.init(
            assets: AssetsCoordinator(mode: .list).strongRouter,
            watchlist: AssetsCoordinator(mode: .favorite).strongRouter,
            settings: SettingsCoordinator().strongRouter
        )
    }

    init(
        assets: StrongRouter<AssetsRoute>,
        watchlist: StrongRouter<AssetsRoute>,
        settings: StrongRouter<SettingsRoute>
    ) {
        self.assets = assets
        self.watchlist = watchlist
        self.settings = settings

        super.init(tabs: [assets, watchlist, settings], select: assets)
    }
}
