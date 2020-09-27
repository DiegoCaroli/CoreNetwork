//
//  EndPointType.swift
//  
//
//  Created by Diego Caroli on 23/09/2020.
//

import Foundation

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var sampleData: Data? { get }
}
