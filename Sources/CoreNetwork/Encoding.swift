//
//  File.swift
//  
//
//  Created by Diego Caroli on 26/09/2020.
//

import Foundation

public struct Encoding: Encodable {
    private let encodable: Encodable

    init(encodable: Encodable) {
        self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
        try encodable.encode(to: encoder)
    }
}
