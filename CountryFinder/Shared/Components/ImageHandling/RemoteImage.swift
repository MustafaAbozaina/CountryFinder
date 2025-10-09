//
//  RemoteImage.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 10/08/2025.
//

import SwiftUI
import UIKit

struct RemoteImage<Content: View>: View {
    let url: URL?
    let placeholder: String
    let isSystemPlaceholder: Bool
    let content: (Image) -> Content
    
    @State private var uiImage: UIImage? = nil
    @State private var isLoading: Bool = false
    
    init(url: URL?,
         placeholder: String = "",
         isSystemPlaceholder: Bool = true,
         @ViewBuilder content: @escaping (Image) -> Content = { $0.resizable() }) {
        self.url = url
        self.placeholder = placeholder
        self.isSystemPlaceholder = isSystemPlaceholder
        self.content = content
    }
        
    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else if isLoading {
                ProgressView()
            } else {
                if isSystemPlaceholder {
                    content(Image(systemName: placeholder))
                } else {
                    content(Image(placeholder))
                }
            }
        }
        .task { load()
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
