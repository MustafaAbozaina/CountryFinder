//
//  DeleteCountryUseCase.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/26/25.
//

import Foundation

protocol DeleteCountryUseCase {
    func execute(country: Country) async throws
}
