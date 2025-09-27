//
//  CountryEntity.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Foundation
import SwiftData

@Model
final class CountryEntity: Identifiable, Hashable {
    @Attribute(.unique) var id: String
    var name: String
    var capital: String?
    var currency: String?
    var flagURL: String?

    init(id: String, name: String, capital: String?, currency: String?, flagURL: String?) {
        self.id = id
        self.name = name
        self.capital = capital
        self.currency = currency
        self.flagURL = flagURL
    }
}

extension CountryEntity: DomainMappable {
    typealias DomainType = Country
    func toDomain() -> Country {
        Country(id: id, name: name, capital: capital, flagURL: flagURL, currency: currency)
    }
}
