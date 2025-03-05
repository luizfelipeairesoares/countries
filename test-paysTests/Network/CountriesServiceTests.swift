//
//  CountriesServiceTests.swift
//  test-paysTests
//
//

import Testing
import Combine
import Foundation

@testable import test_pays

@Suite struct CountriesServiceTests {

    private var cancellables: Set<AnyCancellable> = []

    @Test("CountriesService.all response is successfull based on mocked data.")
    func listAll() async throws {
        var countries: [Country] = []
        let service = CountriesService(provider: createMockNetworkProvider("countriesResponse"))
        try await confirmation(expectedCount: 1) { confirmation in
            service.listAll { result in
                switch result {
                case .success(let response):
                    countries = response
                case .failure(_):
                    break
                }
                #expect(countries.isEmpty == false)
                confirmation()
            }
            try await Task.sleep(for: .seconds(5))
        }
    }

    @Test("CountriesService.searchCountry response is successfull based on mocked data.")
    func searchCountry() async throws {
        var countries: [Country] = []
        let service = CountriesService(provider: createMockNetworkProvider("searchCountryResponse"))
        let countryName = "Canada"
        try await confirmation(expectedCount: 1) { confirmation in
            service.searchCountry(name: countryName) { result in
                switch result {
                case .success(let response):
                    countries = response
                case .failure(_):
                    break
                }
                #expect(countries.isEmpty == false)
                confirmation()
            }
            try await Task.sleep(for: .seconds(5))
        }
    }

    // MARK: - Private

    private func createMockNetworkProvider(_ response: String) -> NetworkProviderProtocol {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        createMockURLHandler(resource: response)
        let session = URLSession(configuration: configuration)
        return NetworkProviderMock(session: session)
    }

    private func createMockURLHandler(resource: String) {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.badRequest
            }
            guard let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ) else {
                throw NetworkError.badRequest
            }
            if let path = Bundle.main.path(forResource: resource, ofType: "json") {
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return (response, data)
            } else {
                throw NetworkError.decodingError
            }
        }
    }

}
