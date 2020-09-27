//
//  URLRequest+Encoding.swift
//  
//
//  Created by Diego Caroli on 26/09/2020.
//

import Foundation

public extension URLRequest {
    mutating func encoded(encodable: Encodable,
                          encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            let encoding = CustomEncodable(encodable: encodable)
            httpBody = try encoder.encode(encoding)

            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json",
                         forHTTPHeaderField: contentTypeHeaderName)
            }

            return self
        } catch {
            throw NetworkError.encodingError(error.localizedDescription)
        }
    }

    mutating func encoded(urlParameters: [String: Any]) throws -> URLRequest {
        guard let url = url else { throw NetworkError.missingURL }

        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false),
           !urlParameters.isEmpty {

            let queryItems = urlParameters.map { key, value -> URLQueryItem in
                let valueString = String(describing: value)
                return URLQueryItem(name: key, value: valueString)
            }
            urlComponents.queryItems = queryItems
            self.url = urlComponents.url
        }

        let contentTypeHeaderName = "Content-Type"
        if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
            setValue("application/x-www-form-urlencoded; charset=utf-8",
                     forHTTPHeaderField: contentTypeHeaderName)
        }

        return self
    }

    mutating func encoded(bodyParameters: [String: Any]) throws -> URLRequest {
        guard !bodyParameters.isEmpty else { return self }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: bodyParameters,
                                                      options: .prettyPrinted)

            httpBody = jsonData

            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json",
                         forHTTPHeaderField: contentTypeHeaderName)
            }

            return self
        } catch {
            throw NetworkError.encodingError(error.localizedDescription)
        }
    }
}



