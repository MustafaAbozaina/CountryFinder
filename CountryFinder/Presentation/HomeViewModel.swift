//
//  HomeViewModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var countries: [Country] = [] {
        didSet {
            isAddingNewCountryDisabled = countries.count >= 5
        }
    }
    @Published var showSearch:Bool = false
    @Published private(set) var isAddingNewCountryDisabled: Bool = false

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
                let countries =  try await loadCountriesUseCase.execute(keyword: "", strategy: .local)
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
        guard countries.count < 5, !countries.contains(country) else {
            return
        }
        Task {
           try? await saveCountryUseCase.execute(country: country)
        }
        countries.append(country)
    }
    
    func removeCountry(atOffsets offsets: IndexSet) {
        let removed = offsets.map { countries[$0] } // capture countries before removal
        countries.remove(atOffsets: offsets)

        Task {
            for country in removed {
                do {
                    try await deleteCountryUseCase.execute(country: country)
                } catch {
                    debugPrint("error is \(error)")
                }
            }
        }
    }
}
