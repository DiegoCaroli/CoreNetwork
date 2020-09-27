
//  NetworkProviderTests.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.

import XCTest
@testable import CoreNetwork

class NetworkProviderTests: XCTestCase {

    var sut: NetworkProvider!
    var mockURLSession: MockURLSession!
    var mockURL: URL!

    override func setUpWithError() throws {
        mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        mockURL = URL(string: "https://www.testapi.com")
    }

    override func tearDownWithError() throws {
        sut = nil
    }


    func testAsanaHost() {
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: TestAPI.asana.sampleData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession)

        sut.fetchAsana() { _ in }
        XCTAssertEqual(mockURLSession.urlComponents?.host,
                       "www.testapi.com")
    }

    func testAsanaPath() {
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: TestAPI.asana.sampleData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession)

        sut.fetchAsana() { _ in }
        XCTAssertEqual(mockURLSession.urlComponents?.path,
                       "/asana")
    }

    func testDakiniPath() {
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: TestAPI.asana.sampleData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession)

        sut.fetchDakini() { _ in }
        XCTAssertEqual(mockURLSession.urlComponents?.path,
                       "/dakini/dao")
    }

    func testDharmaURLParameters() {
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: TestAPI.asana.sampleData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession)

        sut.fetchDharma(term: "Eightfold Path") { _ in }
        XCTAssertEqual(mockURLSession.urlComponents?.url?.query,
                       "term=Eightfold%20Path")
    }

    func testGongHTTPBody() {
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: TestAPI.asana.sampleData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession)

        let user = User(name: "Max", email: "max@gmail.com")
        sut.requestGong(user: user) { _ in }
        XCTAssertNotNil(mockURLSession.httpBody)
    }
    

    func testAsanaImmediateStubSuccessful() {
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: TestAPI.asana.sampleData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession, stubBehavior: .immediate)

        let expectation = XCTestExpectation(description: "Successful")
        sut.fetchAsana() { result in
            switch result {
                case .success(let user):
                    XCTAssertNotNil(user)
                   expectation.fulfill()
                case .failure:
                    XCTFail()
            }
        }

        wait(for: [expectation], timeout: 1)
    }

    func testAsanaDelayStubSuccessful() {
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: TestAPI.asana.sampleData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession, stubBehavior: .delayed(seconds: 5))

        let expectation = XCTestExpectation(description: "Successful")
        sut.fetchAsana() { result in
            switch result {
                case .success(let user):
                    XCTAssertNotNil(user)
                   expectation.fulfill()
                case .failure:
                    XCTFail()
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testAsanaJSONInvalid() {
        let jsonData = "{\"name\":\"max\", \"no_field\":\"max@gmail.com\"}".data(using: .utf8)!
        let urlResponse = HTTPURLResponse(url: mockURL,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)
        mockURLSession = MockURLSession(data: jsonData,
                                        urlResponse: urlResponse,
                                        error: nil)
        setupSession(mockURLSession,
                     stubBehavior: .immediate,
                     endpointSampleResponse: .networkResponse(200, jsonData))

        let expectation = XCTestExpectation(description: "Error")
        sut.fetchAsana { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }

    func testAsanaHTTPStatusError() {
        let response = HTTPURLResponse(url: mockURL,
                                       statusCode: 500,
                                       httpVersion: nil,
                                       headerFields: nil)
        mockURLSession = MockURLSession(data: Data(),
                                        urlResponse: response,
                                        error: nil)
        setupSession(mockURLSession, stubBehavior: .immediate, endpointSampleResponse: .networkResponse(500, Data()))

        let expectation = XCTestExpectation(description: "Error")
        sut.fetchAsana() { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }

    static var allTests = [
        ("testAsanaHost", testAsanaHost),
        ("testAsanaPath", testAsanaPath),
        ("testDakiniPath", testDakiniPath),
        ("testDharmaURLParameters", testDharmaURLParameters),
        ("testGongHTTPBody", testGongHTTPBody),
        ("testAsanaSuccessful", testAsanaImmediateStubSuccessful),
        ("testAsanaDelayStubSuccessful", testAsanaDelayStubSuccessful),
        ("testAsanaJSONInvalid", testAsanaJSONInvalid),
        ("testAsanaHTTPStatusError", testAsanaHTTPStatusError)
    ]

}

private extension NetworkProviderTests {
    func setupSession(_ session: MockURLSession) {
        sut = NetworkProvider(session: session)
    }

    func setupSession(_ session: MockURLSession, stubBehavior: StubBehavior) {
        sut = NetworkProvider(session: session,
                              stubBehavior: stubBehavior)
    }

    func setupSession(_ session: MockURLSession,
                      stubBehavior: StubBehavior,
                      endpointSampleResponse: EndpointSampleResponse) {
        sut = NetworkProvider(session: session,
                              stubBehavior: stubBehavior,
                              endpointSampleResponse: endpointSampleResponse)
    }

}
