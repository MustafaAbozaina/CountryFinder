//
//  CountrySearchView.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import SwiftUI
struct CountrySearchView: View {
    @ObservedObject var viewModel: CountrySearchViewModel
    var onSelect: (Country) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            searchResultsList
                .navigationTitle("Search Countries")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for a country")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                }
                .onChange(of: viewModel.searchText) { _, _ in
                    Task { await viewModel.performSearch() }
                }
        }
    }
    
    private var searchResultsList: some View {
        Group {
            if viewModel.searchResults.isEmpty && !viewModel.searchText.isEmpty {
                ContentUnavailableView("No Results", systemImage: "magnifyingglass")
            } else if viewModel.searchResults.isEmpty {
                emptyView
            } else {
                resultView
            }
        }
    }
    
    private var resultView: some View {
        List(viewModel.searchResults) { country in
            Button(action: { onSelect(country) }) {
                CountryRowView(country: country)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("Search for countries")
                .font(.title2)
            Text("Enter a country name to begin searching")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 48)
    }
}
