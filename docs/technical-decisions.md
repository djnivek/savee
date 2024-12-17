# Technical Decisions Documentation

Here is the template for the technical decisions documentation:
### [Topic]
- **Decision**: What was decided
- **Alternatives Considered**: What other options were evaluated
- **Rationale**: Why this choice was made
- **Consequences**: What are the implications of this decision
- **Trade-offs**: What we gain and what we lose

## Decisions

### 1. Network Client using a internal Swift Package

- **Decision**: Create a Swift package to handle network communication with the server
- **Alternatives Considered**: 
  - Embedding network code directly in the app
  - Using a third-party networking library
  - Creating an internal framework
- **Rationale**: 
  - Easier to maintain and update independently of main app code
  - Reduces app binary size through dynamic framework approach
  - Enables code reuse across multiple apps
- **Consequences**:
  - Need to maintain separate package
  - Additional dependency management
- **Trade-offs**:
  - Gain: Modularity, reusability, smaller app size
  - Lose: Some additional complexity in project setup and maintenance

### 2. MVVM Architecture with Clear Separation of Concerns

- **Decision**: Adopt strict MVVM architecture with clear layer separation and responsibilities
- **Alternatives Considered**: 
  - Clean Architecture with VIPER
  - Redux/TCA (The Composable Architecture)
- **Rationale**: 
  - Better testability through clear separation of concerns
  - Protocol usage enables better modularity and easier mocking for tests
  - View/ViewModel separation simplifies maintenance and code evolution
- **Consequences**:
  - More rigid but clearer project structure
  - Slight increase in initial boilerplate
  - Easier onboarding for new developers
- **Trade-offs**:
  - Gain: Testability, maintainability, clear separation of concerns
  - Lose: More files to manage, not the "latest architecture paradigm"