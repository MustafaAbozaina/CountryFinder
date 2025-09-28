//
//  AppDependencies.swift
//  CountryFinder
//
//  Created by Mustafa Abozaina on 9/28/25.
//

import SwiftData

extension AppDependencyContainer {
     func registerCoreServices() {
        self.register(ModelContainer.self, singleton: self.createSharedModelContainer())
        self.register(NetworkManager.self, singleton: NetworkManager())
        self.register(LocationManager.self, singleton: LocationManager())
    }
    
    private func createSharedModelContainer() -> ModelContainer {
        let schema = Schema([
            CountryEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    func registerUseCases() {
        registerCountriesUseCase()
    }
    
    func registerRepositories() {
        self.register(CountriesRepository.self) {
            let container = self.resolve(ModelContainer.self)
            let localDataSource = DefaultCountriesLocalDataSource(modelContainer: container)
            let remoteDataSource = DefaultCountriesRemoteDataSource(client: self.resolve(NetworkManager.self))
            return DefaultCountriesRepository(local: localDataSource, remote: remoteDataSource)
        }
    }
    
    func registerCountriesUseCase() {
        let countriesRepository = self.resolve(CountriesRepository.self)
        
        self.register(FetchCountriesUseCase.self) {
            DefaultFetchCountriesUseCase(repository: countriesRepository)
        }
        self.register(SaveCountryUseCase.self) {
            DefaultSaveCountryUseCase(repository: countriesRepository)
        }
        self.register(DeleteCountryUseCase.self) {
            DefaultDeleteCountryUseCase(repository: countriesRepository)
        }
        self.register(FindCountryByLocationUseCase.self) {
            DefaultFindCountryByLocationUseCase(
                repository: countriesRepository,
                locationManager: self.resolve(LocationManager.self)
            )
        }
    }
}
