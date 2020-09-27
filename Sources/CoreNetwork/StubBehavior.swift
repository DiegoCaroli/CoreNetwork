//
//  File.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import Foundation

public enum StubBehavior: Equatable {
    case never
    case immediate
    case delayed(seconds: TimeInterval)
}
