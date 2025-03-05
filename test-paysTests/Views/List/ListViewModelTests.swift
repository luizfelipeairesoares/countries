//
//  ListViewModelTests.swift
//  test-pays
//
//

import Testing
import Foundation
import Combine
@testable import test_pays

@Suite struct ListViewModelTests {

    @Test("ListViewModel.loadAll")
    func testLoadAll() {
        let service = CountriesServiceMock(provider: createMockNetworkProvider())
        service.countries = [Country(
            name: CountryName(common: "Canada", official: "Canada"),
            flags: CountryFlag(png: "", svg: "", alt: ""),
            capital: ["Ottawa"],
            population: 38005238,
            continents: ["North America"])
        ]
        let viewModel = ListViewModel(service: service)
        viewModel.loadAll()
        #expect(viewModel.filteredDatasource.isEmpty == false)
        #expect(viewModel.state == .showContent(countries: viewModel.filteredDatasource))
    }

    @Test("ListViewModel.loadAll has empty result")
    func testLoadAllEmptyResult() {
        let service = CountriesServiceMock(provider: createMockNetworkProvider())
        let viewModel = ListViewModel(service: service)
        viewModel.loadAll()
        #expect(viewModel.filteredDatasource.isEmpty == true)
        #expect(viewModel.state == .showContent(countries: []))
    }

    @Test("ListViewModel.loadAlll has error response")
    func testLoadAllFails() {
        let service = CountriesServiceMock(provider: createMockNetworkProvider())
        service.mockFailRequest = true
        service.errorMessage = "Error"
        let viewModel = ListViewModel(service: service)
        viewModel.loadAll()
        #expect(viewModel.filteredDatasource.isEmpty == true)
        #expect(viewModel.state == .error(message: "Error"))
    }

    @Test("ListViewModel.searchCountry")
    func testSearch() {
        let service = CountriesServiceMock(provider: createMockNetworkProvider())
        service.countries = [Country(
            name: CountryName(common: "Canada", official: "Canada"),
            flags: CountryFlag(png: "", svg: "", alt: ""),
            capital: ["Ottawa"],
            population: 38005238,
            continents: ["North America"])
        ]
        let viewModel = ListViewModel(service: service)
        viewModel.searchText = "Canada"
        viewModel.searchCountry()
        #expect(viewModel.filteredDatasource.isEmpty == false)
        #expect(viewModel.state == .showContent(countries: viewModel.filteredDatasource))
    }

    // MARK: - Private

    private func createMockNetworkProvider() -> NetworkProviderProtocol {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        return NetworkProviderMock(session: session)
    }

}
