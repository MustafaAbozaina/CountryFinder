//
//  BannerOverlayModifier.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 10/08/2025.
//

import SwiftUI

struct BannerOverlayModifier: ViewModifier {
    @EnvironmentObject var bannerManager: AppBannerManager

    func body(content: Content) -> some View {
        AppBannerView(manager: bannerManager) {
            content
        }
    }
}

extension View {
    func bannerOverlay() -> some View {
        self.modifier(BannerOverlayModifier())
    }
}
