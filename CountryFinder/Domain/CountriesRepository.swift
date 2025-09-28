//
//  CountriesRepository.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

protocol CountriesRepository {
    func fetchAllCountries(strategy: SearchStrategy) async throws -> [Country]
    func saveCountries(_ countries: [Country]) async throws
    func searchCountries(keyword: String, strategy: SearchStrategy) async throws -> [Country]

    func saveFavoriteCountry(_ country: Country) async throws
    func deleteCountry(_ country: Country) async throws
    func getCachedCountries() async throws -> [Country]
    func getCountriesCount() async -> Int
}

enum SearchStrategy {
    case local
    case remote
}
