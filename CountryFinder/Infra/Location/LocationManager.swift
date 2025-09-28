//
//  LocationManager.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import Foundation
import CoreLocation
import Combine

protocol LocationManagerProtocol {
    var authorizationStatus: CLAuthorizationStatus { get }
    var currentLocation: CLLocation? { get }
    var locationPublisher: AnyPublisher<CLLocation?, Never> { get }
    var authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }
    
    func requestLocationPermission()
    func startLocationUpdates()
    func stopLocationUpdates()
}

final class LocationManager: NSObject, LocationManagerProtocol, ObservableObject {
    private let locationManager = CLLocationManager()
    private let locationSubject = CurrentValueSubject<CLLocation?, Never>(nil)
    private let authorizationSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)
    
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocation: CLLocation?
    
    var locationPublisher: AnyPublisher<CLLocation?, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    
    var authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }
    
    func requestLocationPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            break
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }
    
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationSubject.send(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("Location error: \(error.localizedDescription)")
        locationSubject.send(nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        authorizationSubject.send(status)
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            stopLocationUpdates()
            locationSubject.send(nil)
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
