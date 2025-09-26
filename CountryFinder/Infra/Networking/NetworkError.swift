//
//  NetworkError.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

enum NetworkError: Error, Equatable {
    case statusCode(Int)
    case decoding(Error)
    case invalidURL
    case transport(Error)

    // Equality is only meaningful for statusCode comparisons in tests.
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case let (.statusCode(a), .statusCode(b)): return a == b
        default: return false
        }
    }
}
