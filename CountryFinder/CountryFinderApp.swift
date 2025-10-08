//
//  CountryFinderApp.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import SwiftUI
import SwiftData

@main
struct CountryFinderApp: App {
    let navigationManager: NavigationManager
    let homeViewModel: HomeViewModel
    let appDependencyContainer = AppDependencyContainer.shared
    
    init() {
        let nav = NavigationManager()
        navigationManager = nav
        let router = DefaultHomeViewRouter(navigationManager: nav)
        homeViewModel = HomeViewModel(router: router)
    }

    var body: some Scene {
        WindowGroup {
            Navigator(navigationManager: navigationManager) {
                HomeView(viewModel: homeViewModel)
            } destinationBuilder: { target in
                switch target {
                case .countryDetails(let country):
                    CountryDetailsView(viewModel: CountryDetailsViewModel(country: country))
                }
            } sheetBuilder: { destination in
                switch destination.type {
                case .countrySearch(let onSelect):
                    CountrySearchView(viewModel: CountrySearchViewModel(), onSelect: onSelect)
                }
            }
        }
        .modelContainer(appDependencyContainer.resolve(ModelContainer.self))
    }
}
