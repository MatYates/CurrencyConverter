//
//  CurrencyTests.swift
//  CurrencyConverterTests
//
//  Created by Mat Yates on 15/1/21.
//

import XCTest
@testable import CurrencyConverter

class CurrencyTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreatingObject() {
        let currencyCode: String = ""
        let amount: Double = 1.0
        let testObject = Currency(currencyCode: currencyCode, amount: amount)
        XCTAssertEqual(currencyCode, testObject.currencyCode)
        XCTAssertEqual(amount, testObject.amount)
    }
    
    func testConverting() {
        let currencyCode: String = "AUD"
        let amount: Double = 1.0
        let testObject = Currency(currencyCode: currencyCode, amount: amount)
        let convertedAmount = testObject.convert(amountEur: 1.0)
        XCTAssertEqual(convertedAmount, "A$1.00")
    }
}
