//
//  CountriesService.swift
//  test-pays
//
//

import Foundation
import Combine

protocol CountriesServiceProtocol: NetworkServiceProtocol {

    func listAll(completion: @escaping (Result<[Country], NetworkError>) -> Void)
    func searchCountry(name: String, completion: @escaping (Result<[Country], NetworkError>) -> Void)

}

class CountriesService: CountriesServiceProtocol {

    private let provider: NetworkProviderProtocol
    private var cancellables = [AnyCancellable]()

    required init(provider: NetworkProviderProtocol = NetworkProvider()) {
        self.provider = provider
    }

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
    }

    func searchCountry(name: String, completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        return provider.request(endpoint: RestCountriesAPI.search(name: name))
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
