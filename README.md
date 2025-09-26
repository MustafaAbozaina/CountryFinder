# CountryFinder App (SwiftUI)

This is a fresh implementation of the REST Countries challenge, built as a walking-skeleton-first, vertical-slices project.

## Architecture (high level)
- Infra: Networking (Endpoint, HTTP/NetworkClient), Location, DI Container
- Data: Remote and Local Data Sources, Repository
- Domain: Country model and Use Cases
- Presentation: SwiftUI Views + ViewModels (state + navigation)
