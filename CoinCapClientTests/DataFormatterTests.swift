import XCTest
@testable import CoinCapClient

final class DataFormatterTests: XCTestCase {
    func testChop() throws {
        XCTAssertEqual(DataFormatter.percent("2.8274952112840291"), "2.82%")
        XCTAssertEqual(DataFormatter.percent("2.82"), "2.82%")
        XCTAssertEqual(DataFormatter.percent("2.8"), "2.8%")
        XCTAssertEqual(DataFormatter.percent("2."), "2%")
        XCTAssertEqual(DataFormatter.percent("2"), "2%")
        XCTAssertEqual(DataFormatter.percent(""), "0%")
    }

    func testCurrency() {
        XCTAssertEqual(DataFormatter.usd("34707384583.1210000000000000"), "$34,707,384,583.12")
        XCTAssertEqual(DataFormatter.usd("34707384583.1"), "$34,707,384,583.10")
        XCTAssertEqual(DataFormatter.usd("34707384583"), "$34,707,384,583")
        XCTAssertEqual(DataFormatter.usd("34707384583."), "$34,707,384,583")
        XCTAssertEqual(DataFormatter.usd(""), "$0")
    }
}
