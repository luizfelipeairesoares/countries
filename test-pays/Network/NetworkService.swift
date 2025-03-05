//
//  NetworkService.swift
//  test-pays
//
//

import Foundation
import Combine
import OSLog

public protocol NetworkServiceProtocol {

    init(provider: NetworkProviderProtocol)

}
