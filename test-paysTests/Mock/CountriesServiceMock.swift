//
//  CountriesServiceMock.swift
//  test-pays
//
//

@testable import test_pays

class CountriesServiceMock: CountriesServiceProtocol {

    var countries: [Country] = []
    var mockFailRequest: Bool = false
    var errorMessage: String = ""

    required init(provider: NetworkProviderProtocol) { }

    func listAll(completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        if !mockFailRequest {
            completion(.success(countries))
        } else {

            completion(.failure(createNetworkError(code: 503)))
        }
    }

    func listAll() async throws -> [Country] {
        if !mockFailRequest {
            return countries
        } else {
            throw createNetworkError(code: 503)
        }
    }

    func listAllConcurrently() async throws -> [Country] {
        if !mockFailRequest {
            return countries
        } else {
            throw createNetworkError(code: 503)
        }
    }

    func searchCountry(name: String, completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        if !mockFailRequest {
            completion(.success(countries))
        } else {
            completion(.failure(createNetworkError(code: 503)))
        }
    }

    // MARK: - Private

    private func createNetworkError(code: Int) -> NetworkError {
        let object = ErrorResponseObject(status: code, message: errorMessage)
        let error = NetworkError.error(object)
        return error
    }

}
