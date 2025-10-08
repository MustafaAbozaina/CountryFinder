//
//  Navigator.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import SwiftUI

struct Navigator<Content: View, Destination: View, Sheet: View>: View {
    @ObservedObject var navigationManager: NavigationManager
    let content: () -> Content
    let destinationBuilder: (NavigationTarget) -> Destination
    let sheetBuilder: (PresentedDestination) -> Sheet
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            content()
                .navigationDestination(for: NavigationTarget.self) { target in
                    destinationBuilder(target)
                }
                .sheet(item: $navigationManager.presentedDestination, content: sheetBuilder)
        }
    }
}
