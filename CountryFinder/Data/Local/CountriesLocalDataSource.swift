//
//  CountriesLocalDataSource.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Foundation
import SwiftData

protocol CountriesLocalDataSource {
    func saveCountry(_ country: Country) async throws
    func saveCountries(_ countries: [Country]) async throws
    func getCachedCountries() async throws -> [Country]
    func deleteCountry(_ country: Country) async throws
}

actor CountriesLocalDataSourceActor: CountriesLocalDataSource {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getCachedCountries() async throws -> [Country] {
        let descriptor = FetchDescriptor<CountryEntity>()
        let entities = try context.fetch(descriptor)
        return entities.map { $0.toDomain() }
    }

    func saveCountry(_ country: Country) async throws {
        try upsertCountry_unlocked(country)
        try context.save()
    }

    func saveCountries(_ countries: [Country]) async throws {
        for c in countries {
            try upsertCountry_unlocked(c)
        }
        try context.save()
    }

    func deleteCountry(_ country: Country) async throws {
        let countryId = country.id

        let descriptor = FetchDescriptor<CountryEntity>(
            predicate: #Predicate { $0.id == countryId }
        )

        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
    }

    private func upsertCountry_unlocked(_ country: Country) throws {
        let countryId = country.id

        let descriptor = FetchDescriptor<CountryEntity>(
            predicate: #Predicate { $0.id == countryId }
        )
        let existing = try context.fetch(descriptor).first

        if let e = existing {
            e.name = country.name
            e.capital = country.capital
            e.currency = country.currency
            e.flagURL = country.flagURL
        } else {
            let entity = CountryEntity(
                id: country.id,
                name: country.name,
                capital: country.capital,
                currency: country.currency,
                flagURL: country.flagURL
            )
            context.insert(entity)
        }
    }
}

