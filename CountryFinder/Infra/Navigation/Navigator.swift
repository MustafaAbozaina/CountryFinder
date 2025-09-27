//
//  Navigator.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import SwiftUI

struct Navigator<Content: View, Destination: View>: View {
    @ObservedObject var navigationManager: NavigationManager
    var content: () -> Content
    var destinationBuilder: (NavigationTarget) -> Destination
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            content()
                .navigationDestination(for: NavigationTarget.self) { target in
                    destinationBuilder(target)
                }
        }
    }
}
