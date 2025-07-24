//
//  InsertMoviesBySectionUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//

protocol InsertMoviesBySectionUseCase {
    func insertMoviesBySection(movies: [Movie], sectionName: String)
}

class InsertMoviesBySectionUseCaseImpl: InsertMoviesBySectionUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    func insertMoviesBySection(movies: [Movie], sectionName: String) {
        self.movieRepository.insertMoviesBySection(movies: movies, sectionName: sectionName)
    }
}
