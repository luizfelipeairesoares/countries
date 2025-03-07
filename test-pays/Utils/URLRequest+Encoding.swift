//
//  URLRequest+Encoding.swift
//  test-pays
//
//

import Foundation

extension URLRequest {

    mutating func encoded(encodable: Encodable, encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: encodable)
            httpBody = try encoder.encode(jsonData)

            let contentTypeHeaderName = "Content-Type"
            if value(forHTTPHeaderField: contentTypeHeaderName) == nil {
                setValue("application/json", forHTTPHeaderField: contentTypeHeaderName)
            }

            return self
        } catch {
            throw NetworkError.encodingError(error)
        }
    }

    func encoded(parameters: [String: Any]) throws -> URLRequest {
        guard let url = self.url else {
            throw NetworkError.badRequest
        }
        var newURLRequest = URLRequest(url: url)
        newURLRequest.httpMethod = self.httpMethod
        newURLRequest.allHTTPHeaderFields = self.allHTTPHeaderFields
        guard !parameters.isEmpty else { return self }
        if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems: [URLQueryItem] = []
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            components.queryItems = queryItems
            newURLRequest.url = components.url
        }
        return newURLRequest
    }

}
