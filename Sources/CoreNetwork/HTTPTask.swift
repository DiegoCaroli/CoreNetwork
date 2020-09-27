//
//  HTTPTask.swift
//  
//
//  Created by Diego Caroli on 23/09/2020.
//

import Foundation

public typealias HTTPHeaders = [String: String]
public typealias Parametes = [String: Any]

public enum HTTPTask {
    case requestPlain
    case requestData(Data)
    case requestJSONEncodable(Encodable)
    case requestCustomJSONEncodable(Encodable,
                                    encoder: JSONEncoder)
    case requestParameters(urlParameters: Parametes)
    case requestCompositeData(bodyData: Data,
                              urlParameters: Parametes)
    case requestCompositeParameters(bodyParameters: Parametes,
                                    urlParameters: Parametes)
}
