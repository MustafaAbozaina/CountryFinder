//
//  CountriesRemoteDataSource.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Foundation

protocol CountriesRemoteDataSource {
    func fetchAllCountries(fields: [String]?) async throws -> [Country]
    func searchByName(_ keyword: String, fullText: Bool?) async throws -> [Country]
}

final class DefaultCountriesRemoteDataSource: CountriesRemoteDataSource {
    private let client: NetworkClient

    init(client: NetworkClient) {
        self.client = client
    }

    // Suggested default v3 field list; callers may override
    private var defaultFields: [String] {
        [
            "name",
            "capital",
            "currencies",
            "flags",
            "cca3",
            "region",
            "subregion",
            "population",
            "timezones",
            "latlng"
        ]
    }

    func fetchAllCountries(fields: [String]? = nil) async throws -> [Country] {
        let list = fields ?? defaultFields
        let endpoint = Endpoint.allCountries(fields: list)

        let models: [CountryModel] = try await client.request(endpoint)
        return models.map { $0.toDomain() }
    }

    func searchByName(_ keyword: String, fullText: Bool? = nil) async throws -> [Country] {
        let endpoint = Endpoint.searchByName(keyword, fullText: fullText)
        let models: [CountryModel] = try await client.request(endpoint)
        return models.map { $0.toDomain() }
    }
}
