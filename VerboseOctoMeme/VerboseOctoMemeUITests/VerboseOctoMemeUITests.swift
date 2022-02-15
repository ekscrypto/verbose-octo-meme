//
//  VerboseOctoMemeUITests.swift
//  VerboseOctoMemeUITests
//
//  Created by Dave Poirier on 2022-02-14.
//

import XCTest

class VerboseOctoMemeUITests: XCTestCase {
    
    private let defaultTimeout: TimeInterval = 2.0

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func enterTextAndConfirmResults(text textToEnter: String, results resultsExpected: String) {
        let app: XCUIApplication = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.textFields["UserInputField"].waitForExistence(timeout: defaultTimeout))
        XCTAssertTrue(app.buttons["ParseButton"].waitForExistence(timeout: defaultTimeout))

        XCTAssertFalse(app.buttons["ParseButton"].isEnabled)
        
        app.textFields["UserInputField"].tap()
        app.textFields["UserInputField"].typeText(textToEnter)
        XCTAssertTrue(app.buttons["ParseButton"].isEnabled)
        app.buttons["ParseButton"].tap()
        
        XCTAssertTrue(app.staticTexts["SearchedTextSummary"].waitForExistence(timeout: defaultTimeout))
        XCTAssertEqual(app.staticTexts["SearchedTextSummary"].label, textToEnter)
        
        app.staticTexts["SearchedTextSummary"].swipeUp()

        XCTAssertTrue(app.staticTexts["RequestedResults"].waitForExistence(timeout: defaultTimeout))
        XCTAssertEqual(app.staticTexts["RequestedResults"].label, resultsExpected)
    }

    func testEnterSecondaryAndTapParse_expectsSecondAndSecondary() {
        enterTextAndConfirmResults(text: "Secondary", results: "second secondary")
    }
    
    func testEnterApplepieshoeAndTapParse_expectsApplePieAndShoe() {
        enterTextAndConfirmResults(text: "ApplePieShoe", results: "apple pie shoe")
    }

    func testEnterShoeorapplepieAndTapParse_expectsApplePieAndShoe() {
        enterTextAndConfirmResults(text: "Shoe or Apple Pie", results: "apple pie shoe")
    }
    
    func testEnterSomethingThatIsntMatched_expectsEmpty() {
        enterTextAndConfirmResults(text: "Bugs", results: "")
    }
}
