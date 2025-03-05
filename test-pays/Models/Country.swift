//
//  Country.swift
//  test-pays
//
//

import Foundation

struct Country: Codable, Identifiable, Equatable {

    let id = UUID()
    let name: CountryName
    let flags: CountryFlag
    let capital: [String]
    let population: Int
    let continents: [String]

    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.id == rhs.id
    }
}
