//
//  File.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import Foundation

extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}
