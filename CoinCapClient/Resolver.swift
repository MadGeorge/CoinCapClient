import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register(IRemoteService.self) { RemoteService() }.scope(.shared)
        register(IStorageService.self) { StorageService() }.scope(.shared)
        register(IChangeIconService.self) { ChangeIconService() }.scope(.shared)
    }
}
