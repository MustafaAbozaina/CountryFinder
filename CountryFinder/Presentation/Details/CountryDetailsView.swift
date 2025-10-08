//
//  CountryDetailsView.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import SwiftUI

struct CountryDetailsView: View {
    @ObservedObject var viewModel: CountryDetailsViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                flagHeaderSection
                infoCard
            
                if let mapURL = viewModel.mapURL {
                    mapSection(mapURL)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(viewModel.country.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
        }
        .task {
            viewModel.loadFlagImage()
        }
    }
    
    // MARK: - Header Section
    private var flagHeaderSection: some View {
        VStack(spacing: 16) {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [.blue.opacity(0.1), .purple.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                VStack(spacing: 12) {
                    // Flag with better styling
                    flagImage
                        .frame(width: 120, height: 80)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                        )
                    
                    Text(viewModel.country.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let capital = viewModel.country.capital, !capital.isEmpty {
                        Text(capital)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
            }
        }
    }
    
    private var flagImage: some View {
        Group {
            switch viewModel.flagLoadingState {
            case .loading:
                ProgressView()
                    .scaleEffect(1.2)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .error:
                Image(systemName: "flag.slash")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.secondary)
                    .padding(20)
            }
        }
    }
    
    // MARK: - Main Info Card
    private var infoCard: some View {
        VStack(spacing: 0) {
            cardHeader(title: "Country Information", systemImage: "info.circle")
            
            LazyVStack(spacing: 0) {
                ForEach(viewModel.detailItems) {  item in
                    CountryDetailRowView(
                        icon: item.icon,
                        label: item.label,
                        value: item.value,
                        color: item.color
                    )
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    
    // MARK: - Map Section
    private func mapSection(_ mapURL: URL) -> some View {
        VStack(spacing: 0) {
            cardHeader(title: "Location", systemImage: "map")
            
            Link(destination: mapURL) {
                VStack(spacing: 12) {
                    Image(systemName: "map.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    
                    Text("View on Map")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text("Tap to explore this country's location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color.blue.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(16)
            }
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Helper Views
    private func cardHeader(title: String, systemImage: String) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.5))
    }
    
    private var shareButton: some View {
        ShareLink(item: viewModel.shareText) {
            Image(systemName: "square.and.arrow.up")
                .fontWeight(.medium)
        }
    }
}
