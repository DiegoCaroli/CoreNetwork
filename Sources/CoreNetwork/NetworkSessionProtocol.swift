//
//  NetworkSessionProtocol.swift
//  
//
//  Created by Diego Caroli on 23/09/2020.
//

import Foundation

public protocol NetworkSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: NetworkSessionProtocol {}
