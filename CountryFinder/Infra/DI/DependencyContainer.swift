//
//  DependencyContainer.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

protocol DependencyContainer {
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    func register<T>(_ type: T.Type, singleton: T) 
    func resolve<T>(_ type: T.Type) -> T
}

final class AppDependencyContainer: DependencyContainer {
    
    static let shared: AppDependencyContainer = .init()
    
    private init() {
        registerDependencies()
    }
    
    // Concurrent queue for thread-safety
    private let queue = DispatchQueue(label: "com.countryfinder.container", attributes: .concurrent)

    private var factories: [String: () -> Any] = [:]
    private var singletons: [String: Any] = [:]

    func register<T>(_ type: T.Type, singleton: T) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            self.singletons[String(describing: type)] = singleton
        }
    }

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            self.factories[key] = { factory() }
        }
    }

    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)

        return queue.sync {
            if let builder = factories[key], let instance = builder() as? T {
                return instance
            }
            if let singleton = singletons[key] as? T {
                return singleton
            }
            fatalError("No registration found for type: \(type)") 
        }
    }
    
    private func registerDependencies() {
        registerCoreServices()
        registerRepositories()
        registerUseCases()
    }
}
