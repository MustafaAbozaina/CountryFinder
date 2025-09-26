//
//  CountryDTO.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

struct CountryModel: Decodable {
    let name: String
    let capital: String?
    let region: String?
    let subregion: String?
    let population: Int?
    let flags: Flags
    let currencies: [Currency]?

    // convenient computed property
    var currency: String? { currencies?.first?.code }

    struct Flags: Decodable {
        let svg: String?
        let png: String?
    }

    struct Currency: Decodable, Hashable {
        let code: String?
        let name: String?
        let symbol: String?
    }
}

extension CountryModel: DomainMappable {
    typealias DomainType = Country

    func toDomain() -> Country {
        Country(
            id: UUID().uuidString, // since JSON doesn’t provide id
            name: name,
            capital: capital,
            flagURL: flags.png ?? flags.svg,
            currency: currency
        )
    }
}
