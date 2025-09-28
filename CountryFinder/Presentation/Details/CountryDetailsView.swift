//
//  CountryDetailsView.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import SwiftUI

struct CountryDetailsView: View {
    let country: Country
    @State private var imageLoadingState: LoadingState = .loading
    @State private var showAllDetails = false
    
    private var viewModel: CountryDetailsViewModel {
        CountryDetailsViewModel(country: country)
    }
    
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
        .navigationTitle(country.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
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
                    
                    Text(country.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if let capital = country.capital, !capital.isEmpty {
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
            switch imageLoadingState {
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
        .onAppear {
            loadFlagImage()
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
        Button {
            shareCountryInfo()
        } label: {
            Image(systemName: "square.and.arrow.up")
                .fontWeight(.medium)
        }
    }
    
    // MARK: - Methods
    private func loadFlagImage() {
        guard let urlString = country.flagURL, let url = URL(string: urlString) else {
            imageLoadingState = .error
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let uiImage = UIImage(data: data) {
                    imageLoadingState = .success(Image(uiImage: uiImage))
                } else {
                    imageLoadingState = .error
                }
            }
        }.resume()
    }
    
    private func shareCountryInfo() {
        let info = "\(country.name)\nCapital: \(country.capital ?? "N/A")\nCurrency: \(country.currency ?? "N/A")"
        let activityVC = UIActivityViewController(activityItems: [info], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

// MARK: - Supporting Types
enum LoadingState {
    case loading, success(Image), error
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct CountryDetailsViewModel {
    let country: Country
    
    var detailItems: [CountryDetailItem] {
        let items: [CountryDetailItem] = [
            .init(icon: "building.2.fill", label: "Capital", value: country.capital ?? "", color: .blue),
            .init(icon: "dollarsign.circle.fill", label: "Currency", value: country.currency ?? "", color: .green)
        ]

        return items
    }
    
    var mapURL: URL? {
        guard let name = country.name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
         return URL(string: "https://maps.apple.com/?q=\(name)")
     }

}


struct CountryDetailItem: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let value: String
    let color: Color
}
