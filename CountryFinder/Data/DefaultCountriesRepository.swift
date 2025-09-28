//
//  DefaultCountriesRepository.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Foundation

final class DefaultCountriesRepository: CountriesRepository {
    private let local: CountriesLocalDataSource
    private let remote: CountriesRemoteDataSource

    init(local: CountriesLocalDataSource, remote: CountriesRemoteDataSource) {
        self.local = local
        self.remote = remote
    }

    func fetchAllCountries(strategy: SearchStrategy) async throws -> [Country] {
        switch strategy {
        case .local:
            return try await local.getCachedCountries()
        case .remote:
            let countries = try await remote.fetchAllCountries(fields: nil)
            return countries
        }
    }

    func saveCountries(_ countries: [Country]) async throws {
        try await local.saveCountries(countries)
    }

    // Search either local or remote depending on strategy
    func searchCountries(keyword: String, strategy: SearchStrategy) async throws -> [Country] {
        switch strategy {
        case .local:
            let cached = try await local.getCachedCountries()
            return cached.filter { $0.name.localizedCaseInsensitiveContains(keyword) }
        case .remote:
            let results = try await remote.searchByName(keyword, fullText: false)
            // Write-through: cache the results for offline reuse
            try await local.saveCountries(results)
            return results
        }
    }

    func saveFavoriteCountry(_ country: Country) async throws {
        try await local.saveCountry(country)
    }

    func deleteCountry(_ country: Country) async throws {
        try await local.deleteCountry(country)
    }

    func getCachedCountries() async throws -> [Country] {
        return try await local.getCachedCountries()
    }
    
    func getCountriesCount() async -> Int {
        return await local.localCountriesCount()
    }
}
