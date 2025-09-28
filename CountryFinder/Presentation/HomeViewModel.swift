//
//  HomeViewModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var showSearch:Bool = false
    @Published var isAddingNewCountryDisabled: Bool = false

    let router: HomeViewRouter
    
    @Inject var loadCountriesUseCase: FetchCountriesUseCase
    @Inject var saveCountryUseCase: SaveCountryUseCase
    @Inject var deleteCountryUseCase: DeleteCountryUseCase
    
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
    
    private func initFetchCountries() {
//        TODO: handle logic for fetch and location manager
    }
    
    
    func addCountry(_ country: Country) {
        countries.append(country)
        guard countries.count < 5, !countries.contains(country) else {
            isAddingNewCountryDisabled = true
            return
        }
        countries.append(country)
    }
    
    func removeCountry(atOffsets offsets: IndexSet) {
        countries.remove(atOffsets: offsets)
        Task {
            if let index = offsets.first {
                do {
                   try await deleteCountryUseCase.execute(country: countries[index])
                } catch  {
                    debugPrint("error is \(error)")
                }
            }
        }
    }
}
