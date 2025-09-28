//
//  FindCountryByLocationUseCase.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import Foundation
import Combine
import CoreLocation

protocol FindCountryByLocationUseCase {
    func execute() async throws -> Country
    func getDefaultCountry() async throws -> Country
    var locationPublisher: AnyPublisher<Country?, Never> { get }
}

final class DefaultFindCountryByLocationUseCase: FindCountryByLocationUseCase {
    private let repository: CountriesRepository
    private let locationManager: LocationManager
    private let locationSubject = CurrentValueSubject<Country?, Never>(nil)
    
    var locationPublisher: AnyPublisher<Country?, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    
    init(repository: CountriesRepository, locationManager: LocationManager) {
        self.repository = repository
        self.locationManager = locationManager
        setupLocationHandling()
    }
    
    private func setupLocationHandling() {
        locationManager.authorizationPublisher
            .sink { [weak self] status in
                Task { await self?.handleAuthorizationChange(status) }
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func execute() async throws -> Country {
        // Request location permission and wait for user's decision
        locationManager.requestLocationPermission()
        
        // Wait for authorization decision
        return try await withCheckedThrowingContinuation { continuation in
            var isCompleted = false
            var cancellable: AnyCancellable?
            
            cancellable = locationManager.authorizationPublisher
                .sink { status in
                    guard !isCompleted else { return }
                    
                    switch status {
                    case .authorizedWhenInUse, .authorizedAlways:
                        isCompleted = true
                        cancellable?.cancel()
                        Task {
                            do {
                                let country = try await self.getDefaultCountry()
                                continuation.resume(returning: country)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }
                    case .denied, .restricted:
                        isCompleted = true
                        cancellable?.cancel()
                        Task {
                            do {
                                let country = try await self.getDefaultCountry()
                                continuation.resume(returning: country)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }
                    case .notDetermined:
                        // Still waiting for user decision
                        break
                    @unknown default:
                        // Unknown status
                        isCompleted = true
                        cancellable?.cancel()
                        Task {
                            do {
                                let country = try await self.getDefaultCountry()
                                continuation.resume(returning: country)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }
                    }
                }
        }
    }
    
    
    private func handleAuthorizationChange(_ status: CLAuthorizationStatus) async {
        // We don't need to do anything here since we're always using Egypt
        // This method is kept for potential future use
        debugPrint("Location authorization status changed to: \(status)")
    }
    
    func getDefaultCountry() async throws -> Country {
        let defaultCountry = Country(
            id: "EGY",
            name: "Egypt",
            capital: "Cairo",
            flagURL: "https://flagcdn.com/w320/eg.png",
            currency: "EGP"
        )
        
        return defaultCountry
    }
    
}
