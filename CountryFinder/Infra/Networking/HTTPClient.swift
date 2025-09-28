//
//  HTTPClient.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

protocol HTTPClient {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {}
