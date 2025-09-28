//
//  Injectable.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import SwiftUICore

@propertyWrapper
struct Inject<T> {
    private var value: T

    init(_ container: AppDependencyContainer = AppDependencyContainer.shared) {
        self.value = container.resolve(T.self)
    }

    var wrappedValue: T { value }
}
