//
//  AppDepedencyTesting.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/27/25.
//

import Testing
@testable import CountryFinder

struct MockingViewModelUseCasesExample {
    @Test("Fetch all countries should return a non-empty list")
    func fetchAllCountries() async throws {
        AppDependencyContainer.shared.register(FetchCountriesUseCase.self) {
            MockFetchCountriesUseCase()
        }

        let sut = HomeViewModel(router: MockedHomeRouter())

        try await Task.sleep(nanoseconds: 200_000_000) // 0.2s, enough for Task to complete

        #expect(sut.countries.count == 1)
        #expect(sut.countries.first?.name == "Egypt")
    }
}


class MockFetchCountriesUseCase: FetchCountriesUseCase {
    func execute(keyword: String) async throws -> [CountryFinder.Country] {
        return [Country(id: "123", name: "Egypt", capital: "Cairo", flagURL: "egypt-flag", currency: "EGP")]
    }
}

class MockedHomeRouter: HomeViewRouter {
    func moveToCountryDetails(_ country: CountryFinder.Country) { }
}
