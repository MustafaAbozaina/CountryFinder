//
//  SaveCountryUseCase.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

protocol SaveCountryUseCase {
    func execute(country: Country) async throws
}

final class DefaultSaveCountryUseCase: SaveCountryUseCase {
    private let repository: CountriesRepository
    
    init(repository: CountriesRepository) {
        self.repository = repository
    }
    
    func execute(country: Country) async throws {
        try await repository.saveFavoriteCountry(country)
    }
}
