//
//  CountriesServiceXCTests.swift
//  test-paysTests
//
//

import XCTest
import Combine
@testable import test_pays

final class CountriesServiceXCTests: XCTestCase {

    var countries: [Country]!
    var service: CountriesService!

    override func setUpWithError() throws {
        countries = []
    }

    override func tearDownWithError() throws {

    }

    func testListAllCombine() throws {
        service = CountriesService(provider: createMockNetworkProvider("countriesResponse"))
        let expectation = expectation(description: "Expects successfull response.")
        service.listAll { [weak self] result in
            switch result {
            case .success(let response):
                self?.countries = response
                expectation.fulfill()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        waitForExpectations(timeout: 5)
        XCTAssertTrue(!countries.isEmpty, "Countries array should not be empty.")
    }

    func testListAllConcurrently() throws {
        service = CountriesService(provider: createMockNetworkProvider("countriesResponse"))
        let expectation = expectation(description: "Expects successfull response.")
        Task.init {
            countries = try await service.listAllConcurrently()
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5)
        XCTAssertTrue(!countries.isEmpty, "Countries array should not be empty.")
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
