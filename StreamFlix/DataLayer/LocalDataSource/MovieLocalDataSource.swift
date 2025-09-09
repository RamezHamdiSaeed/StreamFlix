//
//  MovieLocalDataSource.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//
import CoreData
import UIKit

protocol MovieLocalDataSource {
    func retrieveFavoriteMovies() -> [Movie]
    func isFavoriteMovie(movieTitle: String) -> Bool
    func favoriteMovie(movieTitle: String) -> Bool
    func unFavoriteMovie(movieTitle: String) -> Bool
    func insertMoviesBySection(movies: [Movie], sectionName: String)
    func retrieveMoviesBySection(sectionName: String) -> [Movie]
}

final class MovieLocalDataSourceImpl: MovieLocalDataSource {
    
    private var _context: NSManagedObjectContext?
    
    private var context: NSManagedObjectContext? {
        if Thread.isMainThread {
            if _context == nil {
                _context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            }
            return _context
        } else {
            // For background threads, we need to get context on main thread
            var context: NSManagedObjectContext?
            DispatchQueue.main.sync {
                context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            }
            return context
        }
    }
    
    // Alternative: Initialize with context to avoid UIApplication calls
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self._context = context
    }

    func isFavoriteMovie(movieTitle: String) -> Bool {
        guard Thread.isMainThread else {
            var result = false
            DispatchQueue.main.sync {
                result = self.isFavoriteMovie(movieTitle: movieTitle)
            }
            return result
        }
        
        if let movieEntity = self.getMovieByTitle(title: movieTitle) {
            print("🔍 Movie '\(movieTitle)' favorite status: \(movieEntity.isFavorite)")
            return movieEntity.isFavorite
        }
        print("🔍 Movie '\(movieTitle)' not found in database")
        return false
    }

    func favoriteMovie(movieTitle: String) -> Bool {
        guard Thread.isMainThread else {
            var result = false
            DispatchQueue.main.sync {
                result = self.favoriteMovie(movieTitle: movieTitle)
            }
            return result
        }
        
        // FIXED: Create movie if it doesn't exist
        let movieEntity = self.getOrCreateMovieByTitle(title: movieTitle)
        movieEntity.isFavorite = true
        
        do {
            try context?.save()
            print("✅ Movie favorited: \(movieTitle)")
            return true
        } catch {
            print("❌ Error while favoriting movie: \(error)")
            return false
        }
    }

    func unFavoriteMovie(movieTitle: String) -> Bool {
        guard Thread.isMainThread else {
            var result = false
            DispatchQueue.main.sync {
                result = self.unFavoriteMovie(movieTitle: movieTitle)
            }
            return result
        }
        
        if let movieEntity = self.getMovieByTitle(title: movieTitle) {
            movieEntity.isFavorite = false
            do {
                try context?.save()
                print("✅ Movie unfavorited: \(movieTitle)")
                
                // FIXED: Clean up movie if it's no longer needed
                if movieEntity.sections?.count == 0 {
                    context?.delete(movieEntity)
                    try context?.save()
                    print("🗑️ Deleted movie '\(movieTitle)' as it's not in any section")
                }
                
                return true
            } catch {
                print("❌ Error while unfavoriting movie: \(error)")
                return false
            }
        }
        return false
    }

    func insertMoviesBySection(movies: [Movie], sectionName: String) {
        print("💾 Inserting \(movies.count) movies for section: \(sectionName)")
        
        // Always perform Core Data operations on main thread for viewContext
        let insertOperation = {
            guard let context = self.context else {
                print("❌ Context not available for inserting movies")
                return
            }
            
            // FIXED: Get or create section first
            self.createOrFetchSection(sectionName: sectionName) { section in
                
                // FIXED: Clear existing movies from this section but preserve favorites
                self.clearSectionMovies(section: section)
                
                for movie in movies {
                    // FIXED: Check if movie already exists to avoid duplicates
                    let movieEntity = self.getOrCreateMovieEntity(from: movie, context: context)
                    
                    // Add to section if not already added
                    if !(movieEntity.sections?.contains(section) ?? false) {
                        movieEntity.addToSections(section)
                    }
                }
                
                do {
                    try context.save()
                    print("✅ Successfully saved \(movies.count) movies for section: \(sectionName)")
                } catch {
                    print("❌ Failed to save movies for section \(sectionName): \(error)")
                }
            }
        }
        
        if Thread.isMainThread {
            insertOperation()
        } else {
            DispatchQueue.main.async {
                insertOperation()
            }
        }
    }

    func retrieveFavoriteMovies() -> [Movie] {
        guard Thread.isMainThread else {
            var result: [Movie] = []
            DispatchQueue.main.sync {
                result = self.retrieveFavoriteMovies()
            }
            return result
        }
        
        guard let context = self.context else {
            print("❌ Context not available for retrieving favorite movies")
            return []
        }

        let movieRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        movieRequest.predicate = NSPredicate(format: "isFavorite == true")
        
        // FIXED: Add sort descriptor to avoid random order
        movieRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        do {
            let movieEntities = try context.fetch(movieRequest)
            let result = movieEntities.compactMap { entity -> Movie? in
                // FIXED: Only return movies that are actually marked as favorite
                guard entity.isFavorite else { return nil }
                
                return Movie(backdropPath: nil,
                      id: nil,
                      title: entity.title,
                      originalTitle: nil,
                      overview: entity.overview,
                      posterPath: entity.poster,
                      mediaType: nil,
                      adult: nil,
                      originalLanguage: entity.language,
                      genreIds: nil,
                      popularity: nil,
                      releaseDate: entity.releaseDate,
                      video: nil,
                      voteAverage: entity.rating,
                      voteCount: nil)
            }
            
            print("📦 Retrieved \(result.count) favorite movies from cache")
            
            // Debug: Print favorite movies
            for movie in result {
                print("❤️ Favorite: \(movie.title ?? "Unknown")")
            }
            
            return result
        } catch {
            print("❌ Failed to fetch favorite movies: \(error)")
            return []
        }
    }

    func retrieveMoviesBySection(sectionName: String) -> [Movie] {
        guard Thread.isMainThread else {
            var result: [Movie] = []
            DispatchQueue.main.sync {
                result = self.retrieveMoviesBySection(sectionName: sectionName)
            }
            return result
        }
        
        guard let context = self.context else {
            print("❌ Context not available for retrieving movies by section")
            return []
        }

        let sectionRequest: NSFetchRequest<SectionEntity> = SectionEntity.fetchRequest()
        sectionRequest.predicate = NSPredicate(format: "name == %@", sectionName)

        do {
            guard let section = try context.fetch(sectionRequest).first else {
                print("📦 Section '\(sectionName)' not found in cache")
                return []
            }

            let movieRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            movieRequest.predicate = NSPredicate(format: "ANY sections == %@", section)
            movieRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

            let movieEntities = try context.fetch(movieRequest)
            let result = movieEntities.map { entity in
                Movie(
                    backdropPath: nil,
                    id: nil,
                    title: entity.title,
                    originalTitle: nil,
                    overview: entity.overview,
                    posterPath: entity.poster,
                    mediaType: nil,
                    adult: nil,
                    originalLanguage: entity.language,
                    genreIds: nil,
                    popularity: nil,
                    releaseDate: entity.releaseDate,
                    video: nil,
                    voteAverage: entity.rating,
                    voteCount: nil
                )
            }
            print("📦 Retrieved \(result.count) movies from section '\(sectionName)'")
            return result
        } catch {
            print("❌ Failed to fetch movies for section '\(sectionName)': \(error)")
            return []
        }
    }

    // FIXED: New method to clear section movies while preserving favorites
    private func clearSectionMovies(section: SectionEntity) {
        guard let context = self.context else { return }
        
        do {
            let movieRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            movieRequest.predicate = NSPredicate(format: "ANY sections == %@", section)
            
            let moviesToUpdate = try context.fetch(movieRequest)
            
            for movie in moviesToUpdate {
                movie.removeFromSections(section)
                
                // If movie is not favorite and doesn't belong to any section, delete it
                if !movie.isFavorite && movie.sections?.count == 0 {
                    context.delete(movie)
                }
            }
            
            try context.save()
        } catch {
            print("❌ Error clearing section movies: \(error)")
        }
    }

    // FIXED: New method to get or create movie entity to avoid duplicates
    private func getOrCreateMovieEntity(from movie: Movie, context: NSManagedObjectContext) -> MovieEntity {
        if let existing = getMovieByTitle(title: movie.title ?? "") {
            // Update existing movie with new data
            existing.poster = movie.posterPath
            existing.rating = movie.voteAverage ?? 0.0
            existing.releaseDate = movie.releaseDate
            existing.overview = movie.overview
            existing.language = movie.originalLanguage
            return existing
        } else {
            // Create new movie entity
            let movieEntity = MovieEntity(context: context)
            movieEntity.id = UUID()
            movieEntity.title = movie.title
            movieEntity.poster = movie.posterPath
            movieEntity.rating = movie.voteAverage ?? 0.0
            movieEntity.releaseDate = movie.releaseDate
            movieEntity.overview = movie.overview
            movieEntity.language = movie.originalLanguage
            movieEntity.isFavorite = false // Default to false
            return movieEntity
        }
    }

    // FIXED: New method to get or create movie by title
    private func getOrCreateMovieByTitle(title: String) -> MovieEntity {
        if let existing = getMovieByTitle(title: title) {
            return existing
        } else {
            guard let context = self.context else {
                fatalError("Context not available")
            }
            
            let movieEntity = MovieEntity(context: context)
            movieEntity.id = UUID()
            movieEntity.title = title
            movieEntity.isFavorite = false
            return movieEntity
        }
    }

    private func createOrFetchSection(sectionName: String, retrieveSectionAction: ((SectionEntity) -> Void)) {
        guard let context = self.context else { return }
        
        let request: NSFetchRequest<SectionEntity> = SectionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", sectionName)

        do {
            if let existing = try context.fetch(request).first {
                retrieveSectionAction(existing)
            } else {
                let section = SectionEntity(context: context)
                section.id = UUID()
                section.name = sectionName
                try context.save()
                retrieveSectionAction(section)
                print("✅ Created new section: \(sectionName)")
            }
        } catch {
            print("❌ Error while creating/fetching section \(sectionName): \(error)")
        }
    }

    private func getMovieByTitle(title: String) -> MovieEntity? {
        guard let context = self.context,
              let movieTitle = title as String?, !movieTitle.isEmpty else { return nil }
        
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", movieTitle)
        request.fetchLimit = 1
        
        do {
            return try context.fetch(request).first
        } catch {
            print("❌ Error fetching movie by title '\(title)': \(error)")
            return nil
        }
    }
}
