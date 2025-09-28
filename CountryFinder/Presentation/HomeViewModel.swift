//
//  HomeViewModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var countries: [Country] = []
    let router: HomeViewRouter
    
    @Inject var loadCountriesUseCase: FetchCountriesUseCase
    @Inject var saveCountryUseCase: FetchCountriesUseCase
    @Inject var deleteCountryUseCase: FetchCountriesUseCase
    
    init(router: HomeViewRouter) {
        self.router = router
        fetchCountries()
    }
    
    func fetchCountries() {
        Task {
            do {
                let countries =  try await loadCountriesUseCase.execute(keyword: "")
                debugPrint("Mostafa countries \(countries)")
                Task {@MainActor in self.countries = countries }
            } catch {
                debugPrint("Error")
            }
        }
    }
    
    func countryRowTapped(_ country: Country) {
        router.moveToCountryDetails(country)
    }
}
