//
//  HomeViewRouter.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Foundation

protocol HomeViewRouter {
    func moveToCountryDetails(_ country: Country)
}

class DefaultHomeViewRouter: HomeViewRouter {
    let navigationManager: NavigationManager
    
    init(navigationManager: NavigationManager) {
        self.navigationManager = navigationManager
    }
    
    func moveToCountryDetails(_ country: Country) {
        navigationManager.push(.countryDetails(country))
    }
}
