//
//  NetworkProviderMock.swift
//  test-pays
//
//

import Foundation
import Combine
@testable import test_pays

struct NetworkProviderMock: NetworkProviderProtocol {

    let urlSession: URLSession

    // MARK: - Init

    init(session: URLSession = .shared) {
        self.urlSession = session
    }

    func request<T>(endpoint: any NetworkTarget) async throws -> T where T : Decodable {
        guard let request = endpoint.request else {
            throw NetworkError.badRequest
        }
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.unauthorized
        }
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        return decoded
    }
    
    func request<T>(endpoint: any NetworkTarget) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let request = endpoint.request else {
            return Fail(error: NetworkError.badRequest)
                .eraseToAnyPublisher()
        }
        return urlSession.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponseObject.self, from: data) {
                        throw NetworkError.error(errorResponse)
                    }
                    throw NetworkError.unauthorized
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is DecodingError {
                    return NetworkError.decodingError
                } else if let error = error as? NetworkError {
                    return error
                } else {
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }

}
