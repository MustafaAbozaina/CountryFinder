//
//  Country.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

struct Country: Identifiable, Hashable {
    let id: String          // alpha3Code
    let name: String
    let capital: String?
    let flagURL: String?
    let currency: String?
}
