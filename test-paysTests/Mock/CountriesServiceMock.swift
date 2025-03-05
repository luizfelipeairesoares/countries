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
            let object = ErrorResponseObject(status: 503, message: errorMessage)
            let error = NetworkError.error(object)
            completion(.failure(error))
        }
    }
    
    func searchCountry(name: String, completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        if !mockFailRequest {
            completion(.success(countries))
        } else {
            let object = ErrorResponseObject(status: 503, message: errorMessage)
            let error = NetworkError.error(object)
            completion(.failure(error))
        }
    }

}
