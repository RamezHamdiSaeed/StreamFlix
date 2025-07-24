//
//  FavoriteMovieUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//

protocol FavoriteMovieUseCase {
    func favoriteMovie(movieTitle: String) -> Bool
}

class FavoriteMovieUseCaseImpl: FavoriteMovieUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    func favoriteMovie(movieTitle: String) -> Bool {
        self.movieRepository.favoriteMovie(movieTitle: movieTitle)
    }
}
