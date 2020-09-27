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
                return NSLocalizedString("MissingURL",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
            case .noData:
                return NSLocalizedString("NoData",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
            case .invalidResponse:
                return NSLocalizedString("InvalidResponse",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
            case .badRequest(_):
                return NSLocalizedString("BadRequest",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
            case .serverError(_):
                return NSLocalizedString("ServerError",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
                
            case .decodingError(_):
                return NSLocalizedString("DecodingError",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
            case .encodingError(_):
                return NSLocalizedString("EncodingError",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
            case .unknown:
                return NSLocalizedString("Unknown",
                                         bundle: .module,
                                         value: "",
                                         comment: "")
        }
    }
}
