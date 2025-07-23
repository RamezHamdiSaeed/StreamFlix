//
//  IsFavoriteMovieUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//


protocol IsFavoriteMovieUseCase {
    func isFavoriteMovie(movieTitle: String) -> Bool
}

class IsFavoriteMovieUseCaseImpl: IsFavoriteMovieUseCase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    func isFavoriteMovie(movieTitle: String) -> Bool {
        self.movieRepository.isFavoriteMovie(movieTitle: movieTitle)
    }
}
