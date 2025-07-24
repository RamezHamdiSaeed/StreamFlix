//
//  UnFavoriteMovieUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//

protocol UnFavoriteMovieUseCase {
    func unFavoriteMovie(movieTitle: String) -> Bool
}

class UnFavoriteMovieUseCaseImpl: UnFavoriteMovieUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    func unFavoriteMovie(movieTitle: String) -> Bool {
        self.movieRepository.unFavoriteMovie(movieTitle: movieTitle)
    }
}
