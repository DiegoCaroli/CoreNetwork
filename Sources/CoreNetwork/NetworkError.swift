//
//  NetworkError.swift
//  
//
//  Created by Diego Caroli on 23/09/2020.
//

import Foundation

public enum NetworkError: Error {
    case missingURL
    case noData
    case invalidResponse
    case badRequest(String?)
    case serverError(String?)
    case parseError(String?)
    case decodingError(String?)
    case encodingError(String?)
    case unknown
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingURL:
            return "The URL is missing."
        case .noData:
            return "No data received from the server."
        case .invalidResponse:
            return "The server response was invalid (unexpected format)."
        case .badRequest(_):
            return "The request was rejected: 400-499."
        case .serverError(_):
            return "Encoutered a server error."
        case .parseError(_):
            return "There was an error parsing the data."
        case .decodingError(_):
            return "There was an error decoding the data"
        case .encodingError(_):
            return "There was an error encoding the data"
        case .unknown:
            return "Unknown error."
        }
    }
}
