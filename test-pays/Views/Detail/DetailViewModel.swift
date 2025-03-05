//
//  DetailViewModel.swift
//  test-pays
//
//

import Foundation

class DetailViewModel: ObservableObject {

    @Published var country: Country

    // MARK: - Init

    public init(country: Country) {
        self.country = country
    }

}

