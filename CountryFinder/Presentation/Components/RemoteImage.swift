//
//  RemoteImage.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 10/08/2025.
//

import SwiftUI
import UIKit

struct RemoteImage: View {
    let url: URL?
    let placeholder: String
    let isSystemPlaceholder: Bool
    
    @State private var uiImage: UIImage? = nil
    @State private var isLoading: Bool = false
    
    init(url: URL?, placeholder: String = "", isSystemPlaceholder: Bool = true) {
        self.url = url
        self.placeholder = placeholder
        self.isSystemPlaceholder = isSystemPlaceholder
    }

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                (isSystemPlaceholder
                 ? Image(systemName: placeholder)
                 : Image(placeholder))
                .resizable()
                .scaledToFit()
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(.secondary)
            }
        }
        .task {
            load()
        }
    }

    private func load() {
        guard let url, uiImage == nil else {
            return
        }
        isLoading = true
        ImageLoader.shared.loadImage(from: url) { result in
            Task {@MainActor in
                switch result {
                case .success(let image):
                    self.uiImage = image
                case .failure:
                    break
                }
                self.isLoading = false
            }
        }
    }
}
