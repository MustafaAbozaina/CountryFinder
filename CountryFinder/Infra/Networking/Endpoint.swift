//
//  Endpoint.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

struct Endpoint {
    let baseUrl: URL
    let path: String?
    let method: HTTPMethod
    let headers: [String: String]
    let queryItems: [URLQueryItem]
    let body: Data?

    var url: URL? {
        if let path = path, !path.isEmpty {
            // Absolute URL support
            if let absolute = URL(string: path), absolute.scheme != nil {
                var components = URLComponents(url: absolute, resolvingAgainstBaseURL: false)
                if !queryItems.isEmpty {
                    var items = components?.queryItems ?? []
                    items.append(contentsOf: queryItems)
                    components?.queryItems = items
                }
                return components?.url
            }
            // Relative path appended to base with query items
            var components = URLComponents(url: baseUrl.appendingPathComponent(path), resolvingAgainstBaseURL: false)
            if !queryItems.isEmpty {
                var items: [URLQueryItem] = []
                items.append(contentsOf: queryItems)
                components?.queryItems = items
            }
            return components?.url
        } else {
            // No path: use base URL and add query if present
            var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
            if !queryItems.isEmpty {
                var items: [URLQueryItem] = []
                items.append(contentsOf: queryItems)
                components?.queryItems = items
            }
            return components?.url
        }
    }

    init(
        baseUrl: URL = URL(string: "https://restcountries.com/v2/")!,
        path: String? = nil,
        method: HTTPMethod = .get,
        headers: [String: String] = ["Accept": "application/json"],
        queryItems: [URLQueryItem] = [],
        body: Data? = nil
    ) {
        self.baseUrl = baseUrl
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }

    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
}

// MARK: - Convenience dictionary-based query APIs
extension Endpoint {
    /// Convenience initializer accepting a query dictionary instead of URLQueryItem array.
    /// Values are converted via `CustomStringConvertible`; nil values are skipped.
    /// Keys are sorted to stabilize URL ordering for tests.
    init(
        baseUrl: URL = URL(string: "https://restcountries.com/v2/")!,
        path: String? = nil,
        method: HTTPMethod = .get,
        headers: [String: String] = ["Accept": "application/json"],
        query: [String: CustomStringConvertible?],
        body: Data? = nil
    ) {
        let items: [URLQueryItem] = query
            .sorted { $0.key < $1.key }
            .compactMap { key, value in
                guard let value else { return nil }
                return URLQueryItem(name: key, value: String(describing: value))
            }
        self.init(baseUrl: baseUrl, path: path, method: method, headers: headers, queryItems: items, body: body)
    }

    /// Returns a copy of the endpoint with additional query parameters appended.
    func withQuery(_ query: [String: CustomStringConvertible?]) -> Endpoint {
        var items = self.queryItems
        let mapped = query
            .sorted { $0.key < $1.key }
            .compactMap { key, value in
                value.map { URLQueryItem(name: key, value: String(describing: $0)) }
            }
        items.append(contentsOf: mapped)
        return Endpoint(baseUrl: baseUrl, path: path, method: method, headers: headers, queryItems: items, body: body)
    }
}
