import XCTest
@testable import CoinCapClient
import Resolver

final class DITests: XCTestCase {
    @Injected var remote: IRemoteService
    @Injected var storage: IStorageService
    @Injected var changeIcon: IChangeIconService

    func testResolver() throws {
        XCTAssertNotNil(remote)
        XCTAssertNotNil(storage)
        XCTAssertNotNil(changeIcon)
    }

}
