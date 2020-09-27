//
//  StringUrlEscapedTests.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import XCTest
@testable import CoreNetwork

class StringUrlEscapedTests: XCTestCase {

    func testStringEscaped() {
        let originalString = "Hello World"
        let escapedString = "Hello%20World"
        XCTAssertEqual(originalString.urlEscaped, escapedString)
    }

    static var allTests = [
        ("testStringEscaped", testStringEscaped)
    ]

}
