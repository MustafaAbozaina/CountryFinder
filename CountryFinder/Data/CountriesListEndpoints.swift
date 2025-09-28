//
//  CountriesListEndpoint.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//
import Foundation

extension Endpoint {
    static func allCountries(fields: [String]) -> Endpoint {
        Endpoint(
            path: "all",
            queryItems: [URLQueryItem(name: "fields", value: fields.joined(separator: ","))]
        )
    }

    static func searchByName(_ keyword: String, fullText: Bool? = nil) -> Endpoint {
        var items: [URLQueryItem] = []
        if let fullText { items.append(URLQueryItem(name: "fullText", value: fullText ? "true" : "false")) }
        let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? keyword
        return Endpoint(
            path: "name/\(encoded)",
            queryItems: items
        )
    }
}
