//
//  RestCountriesAPI.swift
//  test-pays
//
//

import Foundation
import CryptoKit

enum RestCountriesAPI {

    case all
    case search(name: String)

}

extension RestCountriesAPI: NetworkTarget {

    var baseURL: String {
        return "https://restcountries.com/v3.1/"
    }
    
    var path: String {
        switch self {
        case .all:
            return "all"
        case .search(let name):
            return "name/\(name)"
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var body: NetworkBody {
        var apiParameters: [String: Any] = [:]
        switch self {
        case .all:
            apiParameters["fields"] = "name,flags,capital,continents,population"
            return .requestParameters(parameters: apiParameters)
        default:
            apiParameters["fullText"] = "true"
            apiParameters["fields"] = "name,flags,capital,continents,population"
            return .requestParameters(parameters: apiParameters)
        }
    }
    
    var headers: [String: String] {
        return [:]
    }
}
