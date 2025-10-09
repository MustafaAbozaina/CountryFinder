//
//  AppBannerView.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 10/08/2025.
//

import SwiftUI
import UIKit

struct AppBannerView<Content: View>: View {
    @ObservedObject var manager: AppBannerManager
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack(alignment: .top) {
            content()

            if let banner = manager.banner {
                toast(for: banner)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1000)
                    .padding(.horizontal, 16)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: manager.banner)
    }

    @ViewBuilder
    private func toast(for state: BannerState) -> some View {
        HStack(spacing: 12) {
            Text(state.message)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 8)

            Button(action: { manager.dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.9))
                    .padding(6)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Dismiss banner")
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(state.color)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 6)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
