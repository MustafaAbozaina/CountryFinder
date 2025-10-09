//
//  ContentView.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        countryListView
            .navigationTitle("Saved Countries")
            .toolbar {
                addButton
            }
    }
    
    private var countryListView: some View {
        Group {
            if viewModel.countries.isEmpty {
                emptyStateView
            } else {
                listView
            }
        }
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.countries) { country in
                CountryRowView(country: country)
                    .onTapGesture {
                        viewModel.countryRowTapped(country)
                    }
            }
            .onDelete(perform: viewModel.removeCountry)
        }
        .listStyle(.insetGrouped)
    }
    
    private var addButton: some View {
        Button(action: { viewModel.addCountryButtonTapped() }) {
            Image(systemName: "plus")
                .font(.headline)
                .padding(8)
                .background(Circle().fill(.blue))
                .foregroundColor(.white)
        }
        .disabled(viewModel.isAddingNewCountryDisabled)
        .opacity(viewModel.isAddingNewCountryDisabled ? 0.6 : 1)
    }
}

struct CountryRow: View {
    var country: Country
    
    var body: some View {
        HStack {
            Text(country.name)
            Spacer()
        }
    }
}


private extension HomeView {
    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(.secondary)
            Text("No Saved Countries")
                .font(.title2)
                .fontWeight(.semibold)
            Text("Tap the button below to search and add your favorite countries. You can save up to 5.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            Button(action: { viewModel.addCountryButtonTapped() }) {
                Label("Add Country", systemImage: "plus")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Capsule().fill(Color.blue))
                    .foregroundColor(.white)
            }
            .disabled(viewModel.countries.count >= 5)
            .opacity(viewModel.countries.count >= 5 ? 0.6 : 1)
        }
        .padding(.top, 48)
    }
}
