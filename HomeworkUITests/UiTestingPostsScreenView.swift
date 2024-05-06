import XCTest

final class UiTestingPostsScreenView: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func test_PostsScreenView_navigationTitle_shouldExists() throws {
        let app = XCUIApplication()
        app.launch()
        // GIVEN
        let navigationBar = app.navigationBars["Posts"]
        // THEN
        XCTAssertTrue(navigationBar.waitForExistence(timeout: 5))
    }

    func test_PostsScreenView_listItemRow_shouldOpenAboutUserView() throws {
        let app = XCUIApplication()
        app.launch()
        // GIVEN
        let firstItemFromRow = app.collectionViews.cells.buttons.firstMatch
        let aboutUserScreen = app.otherElements["AboutUserScreen"]
        // WHEN
        firstItemFromRow.tap()
        // THEN
        XCTAssertTrue(aboutUserScreen.waitForExistence(timeout: 5))
    }
}
