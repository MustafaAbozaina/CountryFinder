//
//  PresentedDestination.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 08/10/2025.
//


import Foundation

struct PresentedDestination: Identifiable {
    enum `Type` {
        case countrySearch(onSelect: (Country) -> Void)
    }
    let id = UUID()
    let type: `Type`
}
