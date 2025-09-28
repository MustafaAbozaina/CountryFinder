//
//  HomeViewModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var countries: [Country] = [] {
        didSet {
            isAddingNewCountryDisabled = countries.count >= 5
        }
    }
    @Published var showSearch:Bool = false
    @Published private(set) var isAddingNewCountryDisabled: Bool = false
    @Published private(set) var isLoadingLocation: Bool = false

    let router: HomeViewRouter
    private var cancellables = Set<AnyCancellable>()
    
    @Inject var loadCountriesUseCase: FetchCountriesUseCase
    @Inject var saveCountryUseCase: SaveCountryUseCase
    @Inject var deleteCountryUseCase: DeleteCountryUseCase
    @Inject var findCountryByLocationUseCase: FindCountryByLocationUseCase
    
    init(router: HomeViewRouter) {
        self.router = router
        setup()
    }
    
    private func setup() {
        fetchCountries()
        setupLocationBasedCountryFetching()
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
    
  
    private func setupLocationBasedCountryFetching() {
        guard countries.isEmpty else { return }

        findCountryByLocationUseCase.locationPublisher
            .compactMap { $0 }
            .sink { [weak self] country in
                Task { await self?.addCountryFromLocation(country) }
            }
            .store(in: &cancellables)
        
        Task {@MainActor in
                await self.requestLocationBasedCountry()
        }
    }
    
    @MainActor
    private func requestLocationBasedCountry() async {
        // Double-check: only proceed if no countries exist
        guard countries.isEmpty else { return }
        
        isLoadingLocation = true
        
        do {
            let country = try await findCountryByLocationUseCase.execute()
            await addCountryFromLocation(country)
        } catch {
            debugPrint("Error finding country by location: \(error)")
            await addDefaultCountry()
        }
        
        isLoadingLocation = false
    }
    
    @MainActor
    private func addCountryFromLocation(_ country: Country) async {
        guard countries.isEmpty else { return }
        
        // Check if country is already in the list (shouldn't happen on first run)
        guard !countries.contains(where: { $0.id == country.id }) else { return }
        
        countries.append(country)
        
        do {
            try await saveCountryUseCase.execute(country: country)
        } catch {
            debugPrint("Error saving country: \(error)")
        }
    }
    
    @MainActor
    private func addDefaultCountry() async {
        guard countries.isEmpty else { return }
        
        do {
            let defaultCountry = try await findCountryByLocationUseCase.getDefaultCountry()
            await addCountryFromLocation(defaultCountry)
        } catch {
            debugPrint("Error getting default country: \(error)")
        }
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
