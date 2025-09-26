//
//  DomainMappable.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

/// A simple protocol that maps a data-transfer or persistence model into a domain model.
protocol DomainMappable {
    associatedtype DomainType
    func toDomain() -> DomainType
}
