//
//  CountryRowView.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import SwiftUI

struct CountryRowView: View {
    let country: Country
    
    var body: some View {
        HStack(spacing: 12) {
            flagView
            
            VStack(alignment: .leading, spacing: 2) {
                Text(country.name)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text("\(country.capital ?? "") • \(country.currency ?? "")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(Color(.systemBackground))
        .accessibilityElement(children: .combine)
    }
    
    private var flagView: some View {
        Group {
            if let url = URL(string: country.flagURL ?? "") {
                RemoteImage(url: url, placeholder: "globe")
            }
        }
        .frame(width: 36, height: 36)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color(.systemGray5), lineWidth: 1))
    }
    
    private var placeholderFlag: some View {
        Image(systemName: "globe")
            .foregroundColor(.secondary)
    }
}
