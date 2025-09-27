//
//  CountryModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

struct CountryModel: Decodable {
    let cca3: String
    let name: Name
    let capital: [String]?
    let region: String?
    let subregion: String?
    let population: Int?
    let latlng: [Double]?
    let timezones: [String]?
    let flags: Flags
    let currencies: [String: Currency]?
    let independent: Bool?

    struct Name: Decodable {
        let common: String
        let official: String
        let nativeName: [String: NativeName]?
    }

    struct NativeName: Decodable {
        let official: String
        let common: String
    }

    struct Flags: Decodable {
        let png: String?
        let svg: String?
        let alt: String?
    }

    struct Currency: Decodable, Hashable {
        let name: String?
        let symbol: String?
    }

    var currency: String? {
        currencies?.first?.key
    }
}

extension CountryModel: DomainMappable {
    typealias DomainType = Country

    func toDomain() -> Country {
        Country(
            id: cca3,
            name: name.common,
            capital: capital?.first,
            flagURL: flags.png ?? flags.svg,
            currency: currency
        )
    }
}
