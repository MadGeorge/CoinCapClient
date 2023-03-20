import Foundation
import UIKit
import XCoordinator
import Resolver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    @Injected var storage: IStorageService

    var window: UIWindow?
    let router = RootCoordinator().strongRouter

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if ProcessInfo.processInfo.environment[UITests.Environment.uiTest] == "YES" {
            storage.clearWatched()
        }

        window = UIWindow(frame: UIScreen.main.bounds)
        window.ifLet { router.setRoot(for: $0) }

        return true
    }
}
