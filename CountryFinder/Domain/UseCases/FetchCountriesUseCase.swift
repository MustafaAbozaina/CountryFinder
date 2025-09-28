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
        let strategy: SearchStrategy = await repository.getCountriesCount() < 5 ? .remote : .local
        
        if keyword.isEmpty {
            return try await repository.fetchAllCountries(strategy: strategy)
        } else {
            return try await repository.searchCountries(keyword: keyword, strategy: strategy)
        }
    }
}
