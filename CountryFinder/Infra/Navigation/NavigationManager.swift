//
//  NavigationManager.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import SwiftUI

class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedDestination: PresentedDestination?
    
    func push(_ target: NavigationTarget) {
        path.append(target)
    }
    
    func present(_ destination: PresentedDestination) {
        presentedDestination = destination
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet() {
        presentedDestination = nil
    }
}
