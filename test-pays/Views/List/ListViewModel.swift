//
//  ListViewModel.swift
//  test-pays
//
//

import Foundation
import Combine

protocol ListViewModelProtocol {

    var searchText: String { get }
    var filteredDatasource: [Country] { get }
    var state: ViewState { get }

    func loadAll()
    func searchCountry()

    init(service: CountriesServiceProtocol)

}

class ListViewModel: ListViewModelProtocol, ObservableObject {

    @Published var searchText: String = ""
    @Published var filteredDatasource: [Country]
    @Published var state: ViewState

    private let service: CountriesServiceProtocol
    private var datasource: [Country]

    // MARK: - Init

    required init(service: CountriesServiceProtocol) {
        datasource = []
        filteredDatasource = []
        state = .loading
        self.service = service
    }

    // MARK: - Public

    public func loadAll() {
        state = filteredDatasource.isEmpty ? .loading : .showContent(countries: filteredDatasource)
        request()
    }

    func searchCountry() {
        guard !searchText.isEmpty else {
            filteredDatasource = datasource
            state = .showContent(countries: filteredDatasource)
            return
        }
        state = .loading
        search()
    }

    public func show(_ country: Country) -> DetailView {
        let viewModel = DetailViewModel(country: country)
        return DetailView(viewModel: viewModel)
    }

    // MARK: - Private

    private func request() {
        service.listAll { [weak self] result in
            switch result {
            case .success(let countries):
                self?.datasource.append(contentsOf: countries)
                self?.filteredDatasource = self?.datasource ?? []
                self?.state = .showContent(countries: self?.filteredDatasource ?? [])
            case .failure(let error):
                self?.state = .error(message: error.errorMessage)
            }
        }

    }

    private func search() {
        service.searchCountry(name: searchText) { [weak self] result in
            switch result {
            case .success(let countries):
                self?.filteredDatasource.removeAll()
                self?.filteredDatasource.append(contentsOf: countries)
                self?.state = .showContent(countries: self?.filteredDatasource ?? [])
            case .failure(let error):
                self?.state = .error(message: error.errorMessage)
            }
        }
    }

}

