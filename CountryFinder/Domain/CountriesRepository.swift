//
//  CountriesRepository.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

protocol CountriesCachingRepository {
    func saveFavoriteCountry(_ country: Country) async throws
    func saveCountries(_ countries: [Country]) async throws
    func getCachedCountries() async throws -> [Country]
    func deleteCountry(_ country: Country) async throws
}

protocol CountriesRemoteRepository {
    func fetchRemoteCountries(keyword: String) async throws -> [Country]
    func fetchAllCountries() async throws -> [Country]
}
