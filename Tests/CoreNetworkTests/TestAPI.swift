//
//  TestAPI.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import Foundation
@testable import CoreNetwork

enum TestAPI {
    case asana
    case dakini(String)
    case dharma(String)
    case gong(User)
}

extension TestAPI: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: "https://www.testapi.com") else {
            fatalError("Please provide valid URL")
        }
        return url
    }

    var path: String {
        switch self {
            case .asana:
                return "/asana"
            case .dakini(let dakini):
                return "/dakini/\(dakini)"
            case .dharma:
                return "/dharma"
            case .gong:
                return "/gong"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .asana,
                 .dakini,
                 .dharma:
                return .get
            case .gong:
                return .post
        }
    }

    var task: HTTPTask {
        switch self {
            case .asana,
                 .dakini:
                return .requestPlain
            case .dharma(let term):
                return .requestParameters(urlParameters: ["term": term])
            case .gong(let user):
                return .requestJSONEncodable(user)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var sampleData: Data? {
        return "{\"name\":\"max\", \"email\":\"max@gmail.com\"}".data(using: .utf8)
    }

}
