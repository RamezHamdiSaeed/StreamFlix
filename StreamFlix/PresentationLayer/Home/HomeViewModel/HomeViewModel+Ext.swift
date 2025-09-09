//
//  HomeViewModel+Ext.swift
//  StreamFlix
//
//  Created by ramez Hamdy on 12/08/2025.
//

import Foundation
// MARK: - Network Operations
extension HomeViewModel {

    func fetchAllSectionsData() {
        print("🌐 Starting to fetch all sections data...")
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        pendingAPICallsCount = 5 // Total number of API calls
        
        // Use concurrent queue for network operations
        let networkQueue = DispatchQueue(label: "com.streamflix.network", qos: .userInitiated, attributes: .concurrent)
        
        networkQueue.async { [weak self] in
            self?.getTrendingMovies()
        }
        
        networkQueue.async { [weak self] in
            self?.getTrendingTV()
        }
        
        networkQueue.async { [weak self] in
            self?.getPopularMovies()
        }
        
        networkQueue.async { [weak self] in
            self?.getUpcomingMovies()
        }
        
        networkQueue.async { [weak self] in
            self?.getTopRatedMovies()
        }
    }
    
    private func handleAPICallCompletion() {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.pendingAPICallsCount -= 1
            print("🔄 API call completed. Remaining: \(self.pendingAPICallsCount)")
            
            if self.pendingAPICallsCount <= 0 {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("✅ All API calls completed")
                }
            }
        }
    }

    private func getTrendingMovies() {
        print("🎬 Fetching trending movies...")
        self.getTrendingMoviesUseCase.getTrendingMovies { [weak self] result in
            defer { self?.handleAPICallCompletion() }
            
            switch result {
            case .success(let title):
                print("✅ Trending movies fetched successfully: \(title.results.count) movies")
                DispatchQueue.main.async {
                    self?.trendingMovies = title.results
                }
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results,
                                          sectionName: MoviesSection.trendingMovies.rawValue)
            case .failure(let error):
                print("❌ Error fetching trending movies: \(error)")
                // Keep existing cached data, don't override it
                if self?.trendingMovies.isEmpty == true {
                    if let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                        .retrieveMoviesBySection(sectionName: MoviesSection.trendingMovies.rawValue),
                        !localMoviesData.isEmpty {
                        DispatchQueue.main.async {
                            self?.trendingMovies = localMoviesData
                        }
                    }
                }
            }
        }
    }

    private func getTrendingTV() {
        print("📺 Fetching trending TV...")
        self.getTrendingTVUseCase.getTrendingTV { [weak self] result in
            defer { self?.handleAPICallCompletion() }
            
            switch result {
            case .success(let title):
                print("✅ Trending TV fetched successfully: \(title.results.count) shows")
                DispatchQueue.main.async {
                    self?.trendingTV = title.results
                }
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results, sectionName: MoviesSection.trendingTV.rawValue)
            case .failure(let error):
                print("❌ Error fetching trending TV: \(error)")
                if self?.trendingTV.isEmpty == true {
                    if let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                        .retrieveMoviesBySection(sectionName: MoviesSection.trendingTV.rawValue),
                        !localMoviesData.isEmpty {
                        DispatchQueue.main.async {
                            self?.trendingTV = localMoviesData
                        }
                    }
                }
            }
        }
    }

    private func getPopularMovies() {
        print("🔥 Fetching popular movies...")
        self.getPopularMoviesUseCase.getPopularMovies { [weak self] result in
            defer { self?.handleAPICallCompletion() }
            
            switch result {
            case .success(let title):
                print("✅ Popular movies fetched successfully: \(title.results.count) movies")
                DispatchQueue.main.async {
                    self?.popularMovies = title.results
                }
                self?.insertMoviesBySectionUseCase?.insertMoviesBySection(movies: title.results,
                                                                          sectionName: MoviesSection.popular.rawValue)
            case .failure(let error):
                print("❌ Error fetching popular movies: \(error)")
                if self?.popularMovies.isEmpty == true {
                    if let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                        .retrieveMoviesBySection(sectionName: MoviesSection.popular.rawValue),
                        !localMoviesData.isEmpty {
                        DispatchQueue.main.async {
                            self?.popularMovies = localMoviesData
                        }
                    }
                }
            }
        }
    }

    private func getUpcomingMovies() {
        print("🚀 Fetching upcoming movies...")
        self.getUpcommingMoviesUseCase.getUpcommingMovies { [weak self] result in
            defer { self?.handleAPICallCompletion() }
            
            switch result {
            case .success(let title):
                print("✅ Upcoming movies fetched successfully: \(title.results.count) movies")
                DispatchQueue.main.async {
                    self?.upcomingMovies = title.results
                }
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results,
                    sectionName: MoviesSection.upcomingMovies.rawValue)
            case .failure(let error):
                print("❌ Error fetching upcoming movies: \(error)")
                if self?.upcomingMovies.isEmpty == true {
                    if let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                        .retrieveMoviesBySection(sectionName: MoviesSection.upcomingMovies.rawValue),
                        !localMoviesData.isEmpty {
                        DispatchQueue.main.async {
                            self?.upcomingMovies = localMoviesData
                        }
                    }
                }
            }
        }
    }

    private func getTopRatedMovies() {
        print("⭐ Fetching top rated movies...")
        self.topRatedMoviesUseCase.getTopRatedMovies { [weak self] result in
            defer { self?.handleAPICallCompletion() }
            
            switch result {
            case .success(let title):
                print("✅ Top rated movies fetched successfully: \(title.results.count) movies")
                DispatchQueue.main.async {
                    self?.topRatedMovies = title.results
                }
                self?.insertMoviesBySectionUseCase?
                    .insertMoviesBySection(movies: title.results,
                                           sectionName: MoviesSection.topRated.rawValue)
            case .failure(let error):
                print("❌ Error fetching top rated movies: \(error)")
                if self?.topRatedMovies.isEmpty == true {
                    if let localMoviesData = self?.retrieveMoviesBySectionUseCase?
                        .retrieveMoviesBySection(sectionName: MoviesSection.topRated.rawValue),
                        !localMoviesData.isEmpty {
                        DispatchQueue.main.async {
                            self?.topRatedMovies = localMoviesData
                        }
                    }
                }
            }
        }
    }
}
