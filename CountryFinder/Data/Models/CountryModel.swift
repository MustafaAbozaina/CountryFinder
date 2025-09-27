//
//  CountryModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

struct CountryModel: Decodable {
    let alpha3Code: String?
    let name: String
    let capital: String?
    let region: String?
    let subregion: String?
    let population: Int?
    let flag: String?
    let currencies: [Currency]?

    var currency: String? { currencies?.first?.code }

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
            id: alpha3Code ?? UUID().uuidString,
            name: name,
            capital: capital,
            flagURL: flag,
            currency: currency
        )
    }
}
