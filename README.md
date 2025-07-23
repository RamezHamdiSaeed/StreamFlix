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

## 🧪 Mocking API for Local Testing

To simulate real API responses locally:

- A virtual server was created using [Mockoon](https://mockoon.com/) on macOS.
- You may see `localhost` in some configs. Be sure to switch to the actual base URL when building the production app.

## 🔑 API Key

> ⚠️ **Important:** You need your own API key from [TheMovieDB](https://www.themoviedb.org/documentation/api) to run this app.

- Replace the expired key in `APICaller.swift`:
  ```swift
  struct Constants {
      static let apiKey = "YOUR_API_KEY_HERE"
      static let baseURL = "https://api.themoviedb.org"
  }
