//
//  CountrySearchViewModel.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import Combine
import Foundation

final class CountrySearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Country] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSearchDebounce()
    }
    
    @Inject var fetchCountriesUseCase: FetchCountriesUseCase

    private func setupSearchDebounce() {
            $searchText
                .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] keyword in
                    guard let self else { return }
                    Task {
                        await self.fetchCountries(keyword: keyword)
                    }
                }
                .store(in: &cancellables)
        }
    
    func fetchCountries(keyword: String) async {
        guard !keyword.isEmpty else { return }
        do {
            let countries =  try await fetchCountriesUseCase.execute(keyword: keyword, strategy: .remote)
            Task {@MainActor in self.searchResults = countries }
        } catch {
            debugPrint("Error")
        }
    }
}
