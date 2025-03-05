//
//  NetworkError.swift
//  test-pays
//
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error(_ object: ErrorResponseObject)
    case serverError
    case encodingError(Swift.Error)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknown

    public var errorMessage: String {
        switch self {
        case .error(let object):
            return object.message
        default:
            return self.localizedDescription
        }
    }

}
