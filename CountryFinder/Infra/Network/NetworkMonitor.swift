//
//  NetworkMonitor.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 10/08/2025.
//

import Foundation
import Network
import Combine

public protocol NetworkMonitoring {
    var isOnline: Bool { get }
    var statusPublisher: AnyPublisher<Bool, Never> { get }
    var isExpensive: Bool { get }
    var isConstrained: Bool { get }
}


final class NetworkMonitor: NetworkMonitoring {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "com.countryfinder.networkMonitor", qos: .background)
    private let subject = PassthroughSubject<Bool, Never>()
    
    // Controling external immutability
    @Published private(set) var isOnline: Bool = false
    @Published private(set) var isExpensive: Bool = false
    @Published private(set) var isConstrained: Bool = false
    
    var statusPublisher: AnyPublisher<Bool, Never> {
        subject
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    init(monitor: NWPathMonitor = NWPathMonitor()) {
        self.monitor = monitor
        configureMonitor()
        monitor.start(queue: queue)
    }
    
    private func configureMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            let isConnected = (path.status == .satisfied)
            
            DispatchQueue.main.async {
                self.isOnline = isConnected
                self.isExpensive = path.isExpensive
                self.isConstrained = {
                    if #available(iOS 13.0, *) {
                        return path.isConstrained
                    } else {
                        return false
                    }
                }()
                self.subject.send(isConnected)
            }
        }
    }
}
