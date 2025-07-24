//
//  MovieLocalDataSource.swift.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//
import CoreData
import UIKit

protocol MovieLocalDataSource {
    func isFavoriteMovie(movieTitle: String) -> Bool
    func favoriteMovie(movieTitle: String) -> Bool
    func unFavoriteMovie(movieTitle: String) -> Bool
    func insertMoviesBySection(movies: [Movie], sectionName: String)
    func retrieveMoviesBySection(sectionName: String) -> [Movie]
}

final class MovieLocalDataSourceImpl: MovieLocalDataSource {
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    func isFavoriteMovie(movieTitle: String) -> Bool {
        if let movieEntity =  self.getMovieByTitle(title: movieTitle) {
            return movieEntity.isFavorite
        }
        return false
    }

    func favoriteMovie(movieTitle: String) -> Bool {
        if let movieEntity =  self.getMovieByTitle(title: movieTitle) {
            movieEntity.isFavorite = true
            do {
                try context?.save()
                return true
            } catch {
                print("Error while favoriteMovie")
                return false
            }
        }
        return false
    }

    func unFavoriteMovie(movieTitle: String) -> Bool {
        if let movieEntity =  self.getMovieByTitle(title: movieTitle) {
            movieEntity.isFavorite = false
            do {
                try context?.save()
                return true
            } catch {
                print("Error while favoriteMovie")
                return false
            }
        }
        return false
    }

    func insertMoviesBySection(movies: [Movie], sectionName: String) {
        guard let context = self.context else { return }

        self.deleteAllMovies(bySectionName: sectionName)

        self.createOrFetchSection(sectionName: sectionName) { section in
            for movie in movies {
                let movieEntity = MovieEntity(context: context)
                movieEntity.id = UUID()
                movieEntity.title = movie.title
                movieEntity.poster = movie.posterPath
                movieEntity.rating = movie.voteAverage ?? 0.0
                movieEntity.releaseDate = movie.releaseDate
                movieEntity.isFavorite = false
                movieEntity.overview = movie.overview
                movieEntity.language = movie.originalLanguage
                movieEntity.addToSections(section)
            }

            do {
                try context.save()
            } catch {
                print("Failed to save movies")
            }
        }
    }

    func retrieveMoviesBySection(sectionName: String) -> [Movie] {
        guard let context = self.context else { return [] }

            let sectionRequest: NSFetchRequest<SectionEntity> = SectionEntity.fetchRequest()
            sectionRequest.predicate = NSPredicate(format: "name == %@", sectionName)

            guard let section = try? context.fetch(sectionRequest).first else {
                print("Section not found")
                return []
            }

            let movieRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            movieRequest.predicate = NSPredicate(format: "ANY sections == %@", section)

            do {
                let movieEntities = try context.fetch(movieRequest)
                return movieEntities.map { entity in
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
            } catch {
                print("Fetch failed: \(error)")
                return []
            }
    }

    private func deleteAllMovies(bySectionName sectionName: String) {
        let request: NSFetchRequest<NSFetchRequestResult> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "ANY sections == %@", sectionName)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context?.execute(batchDeleteRequest)
        } catch {
            print("error while deleting")
        }
    }

    private func createOrFetchSection(sectionName: String, retrieveSectionAction: ((SectionEntity) -> Void)) {
        let request: NSFetchRequest<SectionEntity> = SectionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", sectionName)

        if let existing = try? context?.fetch(request).first {
            retrieveSectionAction(existing)
        } else {
            if let context = self.context {
                let section = SectionEntity(context: context)
                section.id = UUID()
                section.name = sectionName
                do {
                    try context.save()
                    retrieveSectionAction(section)
                } catch {
                    print("error while creation of Section")

                }
            }
        }
    }

    private func getMovieByTitle(title: String) -> MovieEntity? {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        return try? context?.fetch(request).first
    }

}
