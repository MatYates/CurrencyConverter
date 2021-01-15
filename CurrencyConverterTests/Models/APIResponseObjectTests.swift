//
//  APIResponseObjectTests.swift
//  CurrencyConverterTests
//
//  Created by Mat Yates on 15/1/21.
//

import XCTest
@testable import CurrencyConverter

class APIResponseObjectTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreatingObject() {
        let base: String = ""
        let date: String = ""
        let success: Bool = true
        let timestamp: Int = 0
        let rates: Dictionary<String, Double> = ["":1.0]
        
        let testObj = APIResponseObject(base: base, date: date, success: success, timestamp: timestamp, rates: rates)
        XCTAssertEqual(base, testObj.base)
        XCTAssertEqual(date, testObj.date)
        XCTAssertEqual(success, testObj.success)
        XCTAssertEqual(timestamp, testObj.timestamp)
        XCTAssertEqual(rates, testObj.rates)
    }
}
