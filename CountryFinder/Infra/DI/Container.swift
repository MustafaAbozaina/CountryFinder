//
//  Container.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

/// A lightweight dependency injection container.
final class Container {
    enum Lifetime {
        case singleton
        case transient
    }

    private var factories: [ObjectIdentifier: () -> Any] = [:]
    private var singletons: [ObjectIdentifier: Any] = [:]

    // Concurrent queue for thread-safety
    private let queue = DispatchQueue(label: "com.countryfinder.container", attributes: .concurrent)

    /// Register a factory for a given type.
    /// - Parameters:
    ///   - type: The protocol or concrete type to register.
    ///   - lifetime: Defaults to `.transient`. Use `.singleton` for shared instances.
    ///   - factory: The factory closure that builds the instance.
    func register<T>(_ type: T.Type, lifetime: Lifetime = .transient, factory: @escaping () -> T) {
        let key = ObjectIdentifier(type)

        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }

            switch lifetime {
            case .singleton:
                self.factories[key] = { [weak self] in
                    if let cached = self?.singletons[key] as? T {
                        return cached
                    }
                    let instance = factory()
                    self?.singletons[key] = instance
                    return instance
                }
            case .transient:
                self.factories[key] = { factory() }
            }
        }
    }

    /// Resolve an instance for the given type.
    /// - Returns: The resolved instance, or crashes if not registered.
    func resolve<T>(_ type: T.Type) -> T {
        let key = ObjectIdentifier(type)
        
        return queue.sync {
            guard let builder = factories[key], let instance = builder() as? T else {
                fatalError("No registration found for type: \(type)")
            }
            return instance
        }
    }
}
