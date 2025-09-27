//
//  CountriesAPITests.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Testing
@testable import CountryFinder

struct CountriesAPITests {
    // System Under Test
    let remote = DefaultCountriesRemoteDataSource(client: NetworkManager())

    @Test("Fetch all countries should return a non-empty list")
    func fetchAllCountries() async throws {
        let countries = try await remote.fetchAllCountries(fields: nil)
        #expect(!countries.isEmpty, "Expected to fetch some countries from API")
    }

    @Test("Search by name 'Jamaica' should return JAM")
    func searchByNameJamaica() async throws {
        let results = try await remote.searchByName("Jamaica", fullText: true)

        #expect(results.first?.id == "JAM")
        #expect(results.first?.name == "Jamaica")
    }
}
