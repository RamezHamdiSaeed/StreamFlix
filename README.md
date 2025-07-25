# 🎬 StreamFlix

**StreamFlix** is a Netflix-inspired iOS app built using the [MovieDB API](https://www.themoviedb.org/documentation/api). It features a modern architecture and clean, scalable codebase.

## 🧩 Architecture

The project follows a **Clean Architecture** design pattern consisting of:

- **Data Layer**: Responsible for data sources (network, local DB).
- **Domain Layer**: Contains business logic, use cases, and interfaces.
- **Presentation Layer (MVVM-C)**:
  - **MVVM**: Model-View-ViewModel for UI separation and testability.
  - **Coordinator**: Handles navigation logic.

## 💡 SOLID Principles

The app is built with SOLID design principles in mind:

- **Single Responsibility Principle**: Each class has one responsibility.
- **Open/Closed Principle**: Home screen supports adding multiple section types via composable `SectionViewModel`s.
- **Liskov Substitution Principle**: Abstract protocols ensure replaceability of implementations.
- **Interface Segregation**: Fat protocols are avoided and split appropriately.
- **Dependency Inversion**: Domain layer depends on abstractions, not concrete data layer implementations.

## 🔁 Reactive Programming

Two branches demonstrate reactive programming approaches:

- `CustomObservable`: Uses a custom lightweight **Observable** implementation to mimic reactivity.
- `main`: Uses Apple’s **Combine** framework for publisher/subscriber pattern.

## 🧹 SwiftLint
This project uses SwiftLint to ensure code style consistency and enforce best practices.

Why SwiftLint?
SwiftLint helps catch common issues such as:

- Force unwrapping (!)

- Long methods (complexity)

- Naming violations

- Unused code

- Redundant return types (like -> Void)

## 🧪 Mocking API for Local Testing

To simulate real API responses locally:

- A virtual server was created using [Mockoon](https://mockoon.com/) on macOS.
- You may see `localhost` in some configs. Be sure to switch to the actual base URL when building the production app.

## ✨ Code Quality with SwiftLint

This project uses [SwiftLint](https://github.com/realm/SwiftLint) to enforce Swift style and conventions:

- Helps maintain clean, readable, and consistent code.
- Automatically highlights issues like force unwrapping, long functions, unused code, etc.
- Run `swiftlint` from the root directory to lint your code manually.

To install SwiftLint:

```sh
brew install swiftlint
```
## 💡 Handling Network and Database Failures

To enhance user experience, the app gracefully handles both **network request failures** and **local database access failures** by:

- Displaying a **friendly feedback image** when no data is available due to an error.
- Supporting with a transparent PNG image background.
- Providing a **pull-to-refresh (Refresher)** mechanism to retry fetching data once the internet connection is restored.

This approach ensures the user is clearly informed when something goes wrong, while offering a seamless way to recover without restarting the app.
