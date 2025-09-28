//
//  ContentView.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        countryListView
    }

    private var countryListView: some View {
        Group {
            if viewModel.countries.isEmpty {
                EmptyView()
            } else {
                listView
            }
        }
    }
    
    private var listView: some View {
        List {
            ForEach(viewModel.countries) { country in
                CountryRow(country: country)
                    .onTapGesture {
                        viewModel.countryRowTapped(country)
                    }
            }
        }
        .listStyle(.insetGrouped)
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
