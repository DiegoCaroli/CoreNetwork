//
//  NetworkProvider.swift
//  
//
//  Created by Diego Caroli on 27/09/2020.
//

import Foundation
@testable import CoreNetwork

class NetworkProvider {
    private let session: NetworkSessionProtocol!
    private let router: Provider<TestAPI>!

    init(session: NetworkSessionProtocol,
         stubBehavior: StubBehavior = .never,
         endpointSampleResponse: EndpointSampleResponse? = nil) {
        self.session = session
        router = Provider<TestAPI>(session: session,
                                   stubBehavior: stubBehavior,
                                   endpointSampleResponse: endpointSampleResponse)
    }

    func fetchAsana(completion: @escaping (Result<User, Error>) -> Void) {
        router.request(.asana) { result in

            do {
                let response = try result.get()
                let user = try response.map(User.self)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchDakini(completion: @escaping (Result<Response, Error>) -> Void) {
        router.request(.dakini("dao")) { result in

            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchDharma(term: String, completion: @escaping (Result<Response, Error>) -> Void) {
        router.request(.dharma(term)) { result in

            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func requestGong(user: User, completion: @escaping (Result<Response, Error>) -> Void) {
        router.request(.gong(user)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func fetchIndra(bodyTerm: String, urlTerm: String, completion: @escaping (Result<Response, Error>) -> Void) {
        router.request(.indra(bodyTerm, urlTerm)) { result in
            do {
                let response = try result.get()
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
    }

}
