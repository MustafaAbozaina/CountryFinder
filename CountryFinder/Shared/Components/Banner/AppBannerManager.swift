//
//  AppBannerManager.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 10/08/2025.
//

import Foundation
import Combine
import SwiftUI

public protocol BannerRouting {
    @MainActor func show(message: String, color: Color, autoHide: TimeInterval?)
    @MainActor func show(error: Error, autoHide: TimeInterval?)
    @MainActor func dismiss()
}

enum BannerKind {
    case offline
    case backOnline
}

struct BannerState: Equatable {
    let kind: BannerKind
    let message: String
    let color: Color
}

final class AppBannerManager: ObservableObject, BannerRouting {
    @Published private(set) var banner: BannerState? = nil

    private let network: NetworkMonitoring
    private var cancellables = Set<AnyCancellable>()
    private var hasReceivedInitial = false
    private var lastOnline: Bool = false

    init(network: NetworkMonitoring) {
        self.network = network
        bind()
    }

    private func bind() {
        network.statusPublisher
            .removeDuplicates()
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .sink { [weak self] online in
                guard let self else { return }
                if !self.hasReceivedInitial {
                    self.hasReceivedInitial = true
                    self.lastOnline = online
                    if !online {
                        self.banner = BannerState(kind: .offline, message: "You’re offline", color: .orange)
                    }
                    return
                }
                self.handleTransition(from: self.lastOnline, to: online)
                self.lastOnline = online
            }
            .store(in: &cancellables)
    }

    private func handleTransition(from old: Bool, to new: Bool) {
        switch (old, new) {
        case (false, true):
            banner = BannerState(kind: .backOnline, message: "Back online", color: .green)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                if self?.banner?.kind == .backOnline {
                    self?.banner = nil
                }
            }
        case (true, false):
            banner = BannerState(kind: .offline, message: "You’re offline", color: .orange)
        default:
            break
        }
    }

    @MainActor
    func dismiss() { banner = nil }

    @MainActor
    func show(message: String, color: Color = .blue, autoHide: TimeInterval? = 2.0) {
        banner = BannerState(kind: .backOnline, message: message, color: color)
        if let seconds = autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
                self?.dismiss()
            }
        }
    }

    @MainActor
    func show(error: Error, autoHide: TimeInterval? = nil) {
        let message = (error as NSError).localizedDescription
        banner = BannerState(kind: .offline, message: message, color: .red)
        if let seconds = autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) { [weak self] in
                self?.dismiss()
            }
        }
    }
}
