//
//  CountryDetailsViewModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 08/10/2025.
//

import SwiftUI

class CountryDetailsViewModel: ObservableObject {
    @Published var flagLoadingState: FlagLoadingState = .loading

    let country: Country
    
    init(country: Country) {
        self.country = country
    }
    
    var detailItems: [CountryDetailItem] {
        let items: [CountryDetailItem] = [
            .init(icon: "building.2.fill", label: "Capital", value: country.capital ?? "", color: .blue),
            .init(icon: "dollarsign.circle.fill", label: "Currency", value: country.currency ?? "", color: .green)
        ]

        return items
    }
    
    var mapURL: URL? {
        guard let name = country.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
         return URL(string: "https://maps.apple.com/?q=\(name)")
     }
    
    var shareText: String {
        "\(country.name)\nCapital: \(country.capital ?? "N/A")\nCurrency: \(country.currency ?? "N/A")"
    }

    
    enum FlagLoadingState {
        case loading, success(Image), error
    }
}

struct CountryDetailItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let value: String
    let color: Color
}
