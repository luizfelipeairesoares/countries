//
//  CountriesService.swift
//  test-pays
//
//

import Foundation
import Combine

protocol CountriesServiceProtocol: NetworkServiceProtocol {

    func listAll(completion: @escaping (Result<[Country], NetworkError>) -> Void)
    func listAll() async throws -> [Country]
    func listAllConcurrently() async throws -> [Country]
    func searchCountry(name: String, completion: @escaping (Result<[Country], NetworkError>) -> Void)

}

class CountriesService: CountriesServiceProtocol {

    private let provider: NetworkProviderProtocol
    private var cancellables = [AnyCancellable]()

    required init(provider: NetworkProviderProtocol = NetworkProvider()) {
        self.provider = provider
    }

    @available(*, renamed: "listAll()")
    func listAll(completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        provider.request(endpoint: RestCountriesAPI.all)
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .sink { receiveCompletion in
                switch receiveCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { response in
                completion(.success(response))
            }
            .store(in: &cancellables)
//        Task {
//            do {
//                let result = try await listAll()
//                completion(.success(result))
//            } catch {
//                completion(.failure(error as! NetworkError))
//            }
//        }
    }
    
    
    func listAll() async throws -> [Country] {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(endpoint: RestCountriesAPI.all)
                .map { $0 }
                .receive(on: DispatchQueue.main)
                .sink { receiveCompletion in
                    switch receiveCompletion {
                    case .failure(let error):
                        continuation.resume(with: .failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { response in
                    continuation.resume(with: .success(response))
                }
                .store(in: &cancellables)
        }
    }

    func listAllConcurrently() async throws -> [Country] {
        do {
            let response: [Country] = try await provider.request(endpoint: RestCountriesAPI.all)
            return response
        } catch {
            throw error
        }
    }

    func searchCountry(name: String, completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        provider.request(endpoint: RestCountriesAPI.search(name: name))
            .map { $0 }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { receiveCompletion in
                switch receiveCompletion {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            }, receiveValue: { response in
                completion(.success(response))
            })
            .store(in: &cancellables)
    }

}
