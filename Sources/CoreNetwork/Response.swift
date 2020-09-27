//
//  Response.swift
//  
//
//  Created by Diego Caroli on 24/09/2020.
//

import Foundation

public struct Response {
    let request: URLRequest
    let response: HTTPURLResponse
    let data: Data
    let statusCode: Int
}

extension Response {
    public func map<D: Decodable>(_ type: D.Type,
                                  decoder: JSONDecoder = JSONDecoder()) throws -> D {
        do {
            return try decoder.decode(D.self, from: data)
        } catch let DecodingError.dataCorrupted(context),
                let DecodingError.keyNotFound(_, context),
                let DecodingError.valueNotFound(_, context),
                let DecodingError.typeMismatch(_, context) {
            throw NetworkError.decodingError(context.debugDescription)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }
}

