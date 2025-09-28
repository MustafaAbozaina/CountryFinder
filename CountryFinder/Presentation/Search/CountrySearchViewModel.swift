//
//  CountrySearchViewModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import Combine

final class CountrySearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Country] = []
    private var countries: [Country] = [] {
        didSet {
            searchResults = countries
        }
    }
    
    @Inject var loadCountriesUseCase: FetchCountriesUseCase
    
    init() {
        fetchCountries()
    }
    
    func fetchCountries() {
        Task {
            do {
                let countries =  try await loadCountriesUseCase.execute(keyword: "")
                Task {@MainActor in self.countries = countries }
            } catch {
                debugPrint("Error")
            }
        }
    }
    
    @MainActor
    func performSearch() async {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        let results = countries.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        searchResults = results
        
    }
}
