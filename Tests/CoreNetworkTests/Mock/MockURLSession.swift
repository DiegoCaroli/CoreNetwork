//
//  MockURLSession.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import Foundation
@testable import CoreNetwork

class MockURLSession: NetworkSessionProtocol {

    private var url: URL?
    private var request: URLRequest?
    private let dataTask: MockTask

    var urlComponents: URLComponents? {
        guard let url = url else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: true)
    }

    var httpBody: Data? {
        guard let request = request else { return nil }
        return request.httpBody
    }

    init(data: Data?,
         urlResponse: URLResponse?,
         error: Error?) {
        dataTask = MockTask(data: data,
                            urlResponse: urlResponse,
                            error: error)
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.request = request
        self.url = request.url
        dataTask.completionHandler = completionHandler
        return dataTask
    }
}
