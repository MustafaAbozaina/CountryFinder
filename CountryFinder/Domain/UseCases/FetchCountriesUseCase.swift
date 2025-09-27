//
//  FetchCountriesUseCase.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

protocol FetchCountriesUseCase {
    func execute(keyword: String) async throws -> [Country]
}

final class DefaultFetchCountriesUseCase: FetchCountriesUseCase {
    private let repository: CountriesRepository
    
    init(repository: CountriesRepository) {
        self.repository = repository
    }
    
    func execute(keyword: String) async throws -> [Country] {
        if keyword.isEmpty {
            return try await repository.fetchAllCountries(strategy: .remote)
        } else {
            return try await repository.searchCountries(keyword: keyword, strategy: .remote)
        }
    }
}
