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

### 3. Dependency Inversion and Injection
- **Decision**: Use dependency injection with protocol-based abstractions, following the Dependency Inversion Principle (DIP)

- **Alternatives Considered**:
  - Singleton pattern
  - Direct concrete implementations

- **Rationale**:
  ```swift
  // ✅ Good: Constructor injection with protocol
  class ChallengeViewModel {
      private let service: ChallengeService
      
      init(service: ChallengeService) {
          self.service = service
      }
  }
  
  // ❌ Bad: Direct concrete dependency
  class ChallengeViewModel {
      private let service = ConcreteChallengeService()
  }
  ```
  - High-level modules don't depend on low-level modules
  - Both depend on abstractions (protocols)
  - Abstractions don't depend on details
  - Easy dependency swapping for testing and flexibility

- **Consequences**:
  - Need to manage dependency graph
  - All dependencies must be passed explicitly
  - Protocol definition required for each service
  - Initial setup overhead for dependency container/composition root

- **Trade-offs**:
  Gains:
  - Testability through easy dependency mocking
  - Flexible configuration
  - Clear component boundaries
  - Better adherence to SOLID principles
  
  Losses:
  - More initial setup code
  - Need to manage dependency lifecycle
  - Slightly more complex initialization

  ### 4. Implementing `actor` for UnsplashService

- **Decision**: Implement the `UnsplashService` as an `actor` to ensure thread safety and simplify concurrency management.
- **Alternatives Considered**:
  - Using a standard Swift class with manual thread safety mechanisms (e.g., `DispatchQueue`).
  - Avoiding thread safety entirely and accepting potential race conditions.
- **Rationale**:
  - `actor` in Swift provides automatic thread safety, reducing the risk of race conditions without additional boilerplate code.
  - Simplifies the implementation by eliminating the need for manual synchronization, such as queues.
  - Aligns with modern Swift concurrency patterns and supports `async/await` for a cleaner API.
  - Enhances maintainability by centralizing thread-safe operations in the `UnsplashService`.
- **Consequences**:
  - The `UnsplashService` becomes reliant on the Swift concurrency model, which may require a modern runtime (e.g., iOS 15 or later).
  - Accessing properties and methods of the actor requires asynchronous calls with `await`, which could add complexity to some use cases.
- **Trade-offs**:
  - **Gain**: 
    - Automatic thread safety.
    - Cleaner and more maintainable code.
    - Enhanced performance through optimized Swift concurrency primitives.
    - Reduced concurrency bugs.
  - **Lose**: 
    - Limited compatibility with older platforms.
    - Requires understanding and adopting the actor model and `async/await`.

### 5. Infinite Scroll Using ScrollView Preference

- **Decision**: Implement a custom ViewModifier based on ScrollView preferences to detect scroll position and trigger pagination
- **Alternatives Considered**: 
  - Sentinel view at the end of the list
  - LazyVStack with onAppear on last item
  - Third-party infinite scroll libraries
- **Rationale**: 
  - Avoids having to manage "sentinel items" in the data model
  - Eliminates the need for polymorphism in the items collection
  - Modifiers: More composable and reusable solution across the app
  - Clear separation of concerns (modifier only knows about scrolling)
  - More SwiftUI-native approach
- **Consequences**: 
  - Uses SwiftUI preference system which can be complex to debug
  - Needs careful threshold tuning for optimal UX
- **Trade-offs**: 
  - Gain: 
    - More modular code
    - No data model pollution
    - Increased reusability
  - Loss:
    - Performance slightly impacted by constant position tracking

### 6. CachedAsyncImage with NSCache

- **Decision**: Create a wrapper around SwiftUI's AsyncImage with NSCache for caching management
- **Alternatives Considered**:
  - Full custom image loading implementation
  - Third-party libraries (Kingfisher, SDWebImage)
  - Custom cache using FileManager or Core Data
  - URL cache configuration
- **Rationale**: 
  - Leverages native SwiftUI AsyncImage component
  - Benefits from future Apple improvements automatically
  - NSCache provides automatic memory management under pressure
  - Maintains codebase aligned with Apple standards
- **Consequences**: 
  - Dependency on AsyncImage behavior
  - In-memory cache only (no persistence)
  - Need to handle cache invalidation manually
- **Trade-offs**: 
  - Gain:
    - Simplified maintenance
    - Automatic updates through SwiftUI
    - Optimized memory management
    - Native SwiftUI integration
  - Loss:
    - Less control over exact loading behavior
    - No persistent cache
    - Limited cache configuration options

### 7. Timer RunLoop Mode Configuration

- **Decision**: Configure timers with RunLoop.main.common mode instead of relying on the default mode from Timer.scheduledTimer

- **Alternatives Considered**:
  - Keep timers in default mode (Timer.scheduledTimer behavior)
  - Create custom scheduling mechanism
  - Use Combine publishers with different scheduling options

- **Rationale**: 
  - Default RunLoop mode (.default) pauses timers during UI tracking events:
    - ScrollView interactions
    - Touch events
    - Gestures
  - Common mode ensures continuous timer execution during these events

- **Consequences**: 
  - Need to explicitly add timers to RunLoop with .common mode
  - Timers will consume more resources as they continue during all UI events
  - More consistent user experience as animations don't pause during scrolling

- **Trade-offs**: 
  - Gain:
    - Smooth, uninterrupted animations during scrolling
    - Consistent timer behavior across all UI states
    - Better user experience for time-sensitive features
  - Loss:
    - Slightly higher battery usage
    - More complex timer setup code
    - Potential for increased CPU usage during heavy UI interaction