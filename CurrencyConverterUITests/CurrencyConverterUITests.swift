//
//  CurrencyConverterUITests.swift
//  CurrencyConverterUITests
//
//  Created by Mat Yates on 15/1/21.
//

import XCTest

class CurrencyConverterUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - XCTestCase

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("uitesting")
    }
    
    // MARK: - Tests
    
    func testCurrencyConverter() {
        app.launch()
        
        //check correct view controller is showing after launch
        XCTAssertTrue(app.otherElements["currencyConverterView"].exists)
        app.textFields.element.tap()
        app.keys["1"].tap()
        app.keys["0"].tap()
        app.keys["0"].tap()
        
        let convertedlabel = app.staticTexts["convertedCurrencyLabel"].label
        XCTAssertNotNil(convertedlabel)
    }
}
