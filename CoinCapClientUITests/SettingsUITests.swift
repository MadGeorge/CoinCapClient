import Foundation
import XCTest

final class CoinCapClientUITests: BaseXCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
        var environment = app.launchEnvironment

        environment[UITests.Environment.uiTest] = "YES"

        app.launchEnvironment = environment
    }

    func testCollectionScrolling() throws {
        app.launch()

        XCTAssertTrue(app.tabBars.firstMatch.wait())

        app.tables.firstMatch.swipeUp()
        tapStatusBar()
    }

    func testTabs() throws {
        app.launch()

        XCTAssertTrue(app.tabBars.firstMatch.wait())

        XCTAssertTrue(app.cells.firstMatch.wait())
        app.cells.firstMatch.swipeLeft()

        if #available(iOS 13.0, *) {
            XCTAssertTrue(app.buttons[UITests.Identifiers.startToWatch].wait())
            app.buttons[UITests.Identifiers.startToWatch].tap()
        } else {
            XCTAssertTrue(app.buttons[UITests.Identifiers.watch].wait())
            app.buttons[UITests.Identifiers.watch].tap()
        }

        sleep(1)

        XCTAssertTrue(app.buttons[UITests.Identifiers.tabWatchlist].wait())
        app.buttons[UITests.Identifiers.tabWatchlist].tap()
        app.buttons[UITests.Identifiers.tabWatchlist].tap()

        sleep(1)

        XCTAssertTrue(app.cells.firstMatch.wait())

        app.cells.firstMatch.swipeLeft()
        if #available(iOS 13.0, *) {
            XCTAssertTrue(app.buttons[UITests.Identifiers.stopToWatch].wait())
            app.buttons[UITests.Identifiers.stopToWatch].tap()
        } else {
            XCTAssertTrue(app.buttons[UITests.Identifiers.remove].wait())
            app.buttons[UITests.Identifiers.remove].tap()
        }

        app.buttons[UITests.Identifiers.tabSettings].tap()
        app.buttons[UITests.Identifiers.tabSettings].tap()

        sleep(1)

        app.buttons[UITests.Identifiers.tabAssets].tap()
        app.buttons[UITests.Identifiers.tabAssets].tap()

        sleep(1)

        if #available(iOS 13.0, *) {
            XCTAssertTrue(app.searchFields.firstMatch.wait())
            app.searchFields.firstMatch.tap()
        } else {
            app.tables.firstMatch.swipeDown()
            XCTAssertTrue(app.searchFields.firstMatch.wait())

            app.searchFields.firstMatch.tap()

            sleep(1)
            app.coordinate(withNormalizedOffset: CGVector(dx: 10, dy: 10)).tap()
        }

        sleep(1)
    }

    func testSettingsRemoveWatching() {
        app.launch()

        XCTAssertTrue(app.tabBars.firstMatch.wait())

        XCTAssertTrue(app.cells.firstMatch.wait())

        for cell in app.cells.allElementsBoundByIndex[0...3] {
            cell.swipeLeft()
            if #available(iOS 13.0, *) {
                XCTAssertTrue(app.buttons[UITests.Identifiers.startToWatch].wait())
                app.buttons[UITests.Identifiers.startToWatch].tap()
            } else {
                XCTAssertTrue(app.buttons[UITests.Identifiers.watch].wait())
                app.buttons[UITests.Identifiers.watch].tap()
            }
        }

        app.buttons[UITests.Identifiers.tabWatchlist].tap()
        app.buttons[UITests.Identifiers.tabWatchlist].tap()

        sleep(1)

        XCTAssertTrue(app.cells.allElementsBoundByIndex.count >= 3)

        app.buttons[UITests.Identifiers.tabSettings].tap()
        app.buttons[UITests.Identifiers.tabSettings].tap()

        XCTAssertTrue(app.cells[UITests.Identifiers.clearWatched].wait())
        app.cells[UITests.Identifiers.clearWatched].tap()

        XCTAssertTrue(app.buttons[UITests.Identifiers.ok].wait())
        app.buttons[UITests.Identifiers.ok].tap()

        app.buttons[UITests.Identifiers.tabWatchlist].tap()

        sleep(2)

        XCTAssertTrue(app.cells.allElementsBoundByIndex.count <= 1)

        sleep(1)
    }

    func testSettingsIconChange() {
        app.launch()

        XCTAssertTrue(app.tabBars.firstMatch.wait())

        app.buttons[UITests.Identifiers.tabSettings].tap()
        app.buttons[UITests.Identifiers.tabSettings].tap()

        sleep(1)

        XCTAssertTrue(app.staticTexts[UITests.Identifiers.icon].wait())
        app.staticTexts[UITests.Identifiers.icon].tap()

        sleep(1)

        for cell in app.cells.allElementsBoundByIndex {
            if !cell.isSelected {
                cell.tap()
                break
            }
        }

        XCTAssertTrue(app.buttons[UITests.Identifiers.ok].wait())
        app.buttons[UITests.Identifiers.ok].tap()

        sleep(1)
    }
}
