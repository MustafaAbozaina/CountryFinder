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
    @StateObject var navigationManager = NavigationManager()
    let appDependencyContainer = AppDependencyContainer.shared

    var body: some Scene {
        WindowGroup {
            Navigator(navigationManager: navigationManager) {
                HomeView(viewModel: HomeViewModel(router: DefaultHomeViewRouter(navigationManager: navigationManager) ))
            } destinationBuilder: { target in
                switch target {
                case .countryDetails(let country):
                    CountryDetailsView(country: country)
                }
            }
        }
        .modelContainer(appDependencyContainer.resolve(ModelContainer.self))
    }
}
