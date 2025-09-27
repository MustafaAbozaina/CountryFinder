//
//  EndpointTests.swift
//  CountryFinderTests
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation
import Testing
@testable import CountryFinder

struct EndpointTests {

    @Test func buildsRelativeURLWithQueryItems() async throws {
        let endpoint = Endpoint(
            baseUrl: URL(string: "https://restcountries.com/v3/")!,
            path: "name/egypt",
            queryItems: [URLQueryItem(name: "fullText", value: "true")]
        )
        #expect(endpoint.url?.absoluteString == "https://restcountries.com/v3/name/egypt?fullText=true")
    }

    @Test func buildsAbsoluteURLWithQueryItems() async throws {
        let endpoint = Endpoint(
            baseUrl: URL(string: "https://example.com/")!,
            path: "https://api.example.com/resources",
            queryItems: [URLQueryItem(name: "q", value: "test"), URLQueryItem(name: "page", value: "1")]
        )
        let url = try #require(endpoint.url)
        #expect(url.absoluteString == "https://api.example.com/resources?q=test&page=1")
    }

    @Test func buildsBaseURLWithQueryItemsWhenPathMissing() async throws {
        let endpoint = Endpoint(
            baseUrl: URL(string: "https://restcountries.com/v2/")!,
            path: nil,
            queryItems: [URLQueryItem(name: "lang", value: "en")]
        )
        let url = try #require(endpoint.url)
        // URLComponents may normalize trailing slashes; accept either
        #expect(url.absoluteString == "https://restcountries.com/v2/?lang=en" || url.absoluteString == "https://restcountries.com/v2?lang=en")
    }
}
