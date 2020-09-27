//
//  MockTask.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import Foundation

class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let responseError: Error?

    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    var completionHandler: CompletionHandler?

    init(
        data: Data?,
        urlResponse: URLResponse?,
        error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.responseError = error
    }

    override func resume() {
        DispatchQueue.main.async { [weak self] in
            self?.completionHandler?(self?.data,
                                     self?.urlResponse,
                                     self?.responseError)
        }
    }

}
