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
    case decodingError(String?)
    case encodingError(String?)
    case unknown
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingURL:
            return NSLocalizedString("MissingURL", comment: "")
        case .noData:
            return NSLocalizedString("NoData", comment: "")
        case .invalidResponse:
            return NSLocalizedString("InvalidResponse", comment: "")
        case .badRequest(_):
            return NSLocalizedString("BadRequest", comment: "")
        case .serverError(_):
            return NSLocalizedString("ServerError", comment: "")
        case .decodingError(_):
            return NSLocalizedString("DecodingError", comment: "")
        case .encodingError(_):
            return NSLocalizedString("EncodingError", comment: "")
        case .unknown:
            return NSLocalizedString("Unknown", comment: "")
        }
    }
}
