//
//  File.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import Foundation

enum EnvironmentVariables: String {
    case verboseNetworkLogger = "verbose_network_logger"

    private var value: String {
        let val = ProcessInfo.processInfo.environment[rawValue]
        return val ?? ""
    }

    var level: Int? {
        return Int(value)
    }
}
