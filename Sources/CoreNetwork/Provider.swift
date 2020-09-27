//
//  Provider.swift
//  
//
//  Created by Diego Caroli on 23/09/2020.
//

import Foundation

public typealias StatusCodeCompletion = (Result<Data, NetworkError>) -> Void
public typealias HandleResponseCompletion = (Result<Data, Error>) -> Void
public typealias RequestCompletion = (Result<Response, Error>) -> Void

public protocol ProviderType: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint,
                 completion: @escaping (Result<Response, Error>) -> Void)
    func cancel()
}

open class Provider<EndPoint: EndPointType>: ProviderType {
    private let session: NetworkSessionProtocol
    private let timeoutInterval: TimeInterval
    private var task: URLSessionTask?
    private let stubBehavior: StubBehavior
    private let endpointSampleResponse: EndpointSampleResponse?
    
    public init(session: NetworkSessionProtocol,
                timeoutInterval: TimeInterval = 30.0,
                stubBehavior: StubBehavior = .never,
                endpointSampleResponse: EndpointSampleResponse? = nil) {
        self.session = session
        self.timeoutInterval = timeoutInterval
        self.stubBehavior = stubBehavior
        self.endpointSampleResponse = endpointSampleResponse
    }
    
    public func request(_ route: EndPoint, completion: @escaping RequestCompletion) {
        do {
            let request = try self.urlRequest(from: route)
            
            if stubBehavior == .never {
                sendRequest(request, completion: completion)
            } else {
                stubRequest(route, request: request, completion: completion)
            }
        } catch {
            completion(.failure(error))
        }
        self.task?.resume()
    }
    
    public func cancel() {
        task?.cancel()
    }
    
    private func sendRequest(_ request: URLRequest, completion: @escaping RequestCompletion) {
        task = session.dataTask(
            with: request,
            completionHandler: { [weak self] data, urlResponse, error in
                self?.handleResponse(data: data,
                                     urlResponse: urlResponse,
                                     error: error) { result in
                    switch result {
                        case .success(let data):
                            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                                completion(.failure(NetworkError.invalidResponse))
                                return
                            }
                            
                            let response = Response(request: request,
                                                    response: urlResponse,
                                                    data: data,
                                                    statusCode: urlResponse.statusCode)
                            self?.log(response: response)
                            completion(.success(response))
                        case .failure(let error):
                            completion(.failure(error))
                    }
                }
            })
    }
    
    private func stubRequest(_ route: EndPoint,
                             request: URLRequest,
                             completion: @escaping RequestCompletion) {
        if !route.sampleData.isEmpty {
            if case .delayed(let seconds) = stubBehavior {
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [self] in
                    do {
                        let response = try buildResponse(route,
                                                         request: request,
                                                         data: route.sampleData)
                        
                        completion(.success(response))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else {
                do {
                    let response = try self.buildResponse(route,
                                                          request: request,
                                                          data: route.sampleData)
                    
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
        } else {
            completion(.failure(NetworkError.noData))
        }
    }
    
    private func buildResponse(_ route: EndPoint,
                               request: URLRequest,
                               data: Data) throws -> Response {
        let response: Response
        
        switch endpointSampleResponse {
            case .networkResponse(let statusCode, let data):
                let urlResponse = try buildHTTPURLResponse(route,
                                                           statusCode: statusCode,
                                                           request: request)
                response = Response(request: request,
                                    response: urlResponse,
                                    data: data,
                                    statusCode: urlResponse.statusCode)
            case .none:
                let urlResponse = try buildHTTPURLResponse(route,
                                                           statusCode: 200,
                                                           request: request)
                response = Response(request: request,
                                    response: urlResponse,
                                    data: data,
                                    statusCode: urlResponse.statusCode)
        }
        
        return response
    }
    
    private func buildHTTPURLResponse(_ route: EndPoint,
                                      statusCode: Int,
                                      request: URLRequest) throws -> HTTPURLResponse {
        let urlResponse = HTTPURLResponse(
            url: route.baseURL.appendingPathComponent(route.path),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: route.headers)
        
        guard let response = urlResponse else {
            throw NetworkError.invalidResponse
        }
        
        return response
    }
    
    private func urlRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: timeoutInterval)
        
        request.httpMethod = route.httpMethod.rawValue
        request.allHTTPHeaderFields = route.headers
        
        switch route.task {
            case .requestPlain:
                return request
            case .requestData(let data):
                request.httpBody = data
                return request
            case .requestJSONEncodable(let encodable):
                return try request.encoded(encodable: encodable)
            case .requestCustomJSONEncodable(let encodable, let encoder):
                return try request.encoded(encodable: encodable, encoder: encoder)
            case .requestParameters(let urlParameters):
                return try request.encoded(urlParameters: urlParameters)
            case .requestCompositeData(let bodyData, let urlParameters):
                request.httpBody = bodyData
                return try request.encoded(urlParameters: urlParameters)
            case .requestCompositeParameters(let bodyParameters, let urlParameters):
                request = try request.encoded(bodyParameters: bodyParameters)
                return try request.encoded(urlParameters: urlParameters)
        }
    }
    
    private func handleResponse(data: Data?,
                                urlResponse: URLResponse?,
                                error: Error?,
                                completion: @escaping HandleResponseCompletion) {
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        
        verifyStatusCode(data: data, urlResponse: urlResponse, error: error) { result in
            switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    private func verifyStatusCode(data: Data?,
                                  urlResponse: HTTPURLResponse,
                                  error: Error?,
                                  completion: @escaping StatusCodeCompletion) {
        switch urlResponse.statusCode {
            case 200...299:
                if let data = data {
                    completion(.success(data))
                } else {
                    completion(.failure(.noData))
                }
            case 400...499:
                completion(.failure(.badRequest(error?.localizedDescription)))
            case 500...599:
                completion(.failure(.serverError(error?.localizedDescription)))
            default:
                completion(.failure(.unknown))
        }
    }
    
    private func log(response: Response) {
        if EnvironmentVariables.verboseNetworkLogger.level != nil  {
            NetworkLogger.log(response: response)
        }
    }
    
}
