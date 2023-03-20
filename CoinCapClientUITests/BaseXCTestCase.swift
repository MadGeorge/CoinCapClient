import Foundation
import XCTest

extension XCUIElement {
  public func wait() -> Bool {
    waitForExistence(timeout: 5)
  }
}

class BaseXCTestCase: XCTestCase {
  let app = XCUIApplication()

  var bundle: Bundle { Bundle(for: BaseXCTestCase.self) }

  override class var runsForEachTargetApplicationUIConfiguration: Bool { false }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func localized(_ key: String) -> String {
      NSLocalizedString(key, bundle: bundle, comment: "")
  }
}

extension BaseXCTestCase {
  func tapStatusBar() {
    app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.02)).tap()
  }

  var backButton: XCUIElement? {
    app.buttons
      .matching(identifier: UITests.Identifiers.backButton)
      .allElementsBoundByIndex
      .last
  }

  var closeButton: XCUIElement? {
    app.buttons
      .matching(identifier: UITests.Identifiers.closeButton)
      .allElementsBoundByIndex
      .last
  }
}
