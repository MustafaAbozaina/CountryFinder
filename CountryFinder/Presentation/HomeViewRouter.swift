//
//  HomeViewRouter.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Foundation

protocol HomeViewRouter {
    func showCountryDetails(_ country: Country)
    func showSearch(onSelect: @escaping (Country) -> Void)
}

class DefaultHomeViewRouter: HomeViewRouter {
    let navigationManager: NavigationManager
    
    init(navigationManager: NavigationManager) {
        self.navigationManager = navigationManager
    }
    
    func showCountryDetails(_ country: Country) {
        navigationManager.push(.countryDetails(country))
    }
    
        
    func showSearch(onSelect: @escaping (Country) -> Void) {
        navigationManager.present(PresentedDestination(type: .countrySearch { [weak self] selected in
            guard let self else { return }
            onSelect(selected)
            self.navigationManager.dismissSheet()
        }))
    }
}
