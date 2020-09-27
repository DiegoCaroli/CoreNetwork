//
//  File.swift
//  
//
//  Created by Diego Caroli on 26/09/2020.
//

import Foundation

class NetworkLogger {
    static func log(response: Response) {

        print("\n - - - - - - - - NETWORK LOGGER - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }

        var logOutput = ""

        switch EnvironmentVariables.verboseNetworkLogger.level {
            case 1:
                logOutput = generateLogStringLevel1(response: response)
            case 2:
                logOutput = generateLogStringLevel2(response: response)
            case 3:
                logOutput = generateLogStringLevel3(response: response)
            case 4:
                logOutput = generateLogStringLevel4(response: response)
            default:
                break
        }

        print(logOutput)
    }

    static func generateLogStringLevel1(response: Response) -> String {
        var logOutput = ""

        let urlAsString = response.request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = response.request.httpMethod != nil ? "\(response.request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        logOutput += ("\n - - - - - - - - - - REQUEST - - - - - - - - - - \n")
        logOutput += """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in response.request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = response.request.httpBody {
            logOutput += "\n \(String(data: body, encoding: .utf8) ?? "")"
        }

        return logOutput
    }

    static func generateLogStringLevel2(response: Response) -> String {
        var logOutput = ""

        logOutput += ("\n - - - - - - - - - - RESPONSE - - - - - - - - - - \n")
        logOutput += "\n StatusCode: \(response.statusCode)"
        logOutput += "\n Data: \(response.data)"

        return logOutput
    }

    static func generateLogStringLevel3(response: Response) -> String {
        var logOutput = ""

        logOutput += generateLogStringLevel1(response: response)
        logOutput += generateLogStringLevel2(response: response)

        return logOutput
    }

    static func generateLogStringLevel4(response: Response) -> String {
        var logOutput = ""

        logOutput += generateLogStringLevel3(response: response)

        if !response.data.isEmpty {
            do {
                let object = try JSONSerialization.jsonObject(with: response.data, options: [.mutableContainers])
                let data = try JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])

                if let prettyPrintedString = String(data: data, encoding: .utf8) {
                    logOutput += "\n \(prettyPrintedString)"
                }
            } catch {
                if let string = String(data: response.data, encoding: .utf8) {
                    logOutput += "\n \(string)"
                }
            }
        }

        return logOutput
    }

}
