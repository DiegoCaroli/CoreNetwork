import XCTest

import CoreNetworkTests

var tests = [XCTestCaseEntry]()
tests += NetworkServiceTests.allTests()
tests += StringUrlEscapedTests.allTests()
XCTMain(tests)
