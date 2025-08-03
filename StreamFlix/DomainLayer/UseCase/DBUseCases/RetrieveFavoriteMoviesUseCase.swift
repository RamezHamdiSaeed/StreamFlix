//
//  RetrieveFavoriteMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 26/07/2025.
//

protocol RetrieveFavoriteMoviesUseCase {
    func retrieveFavoriteMovies() -> [Movie]
}

class RetrieveFavoriteMoviesUseCaseImpl: RetrieveFavoriteMoviesUseCase {
    
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }
    
    func retrieveFavoriteMovies() -> [Movie] {
        self.movieRepository.retrieveFavoriteMovies()
    }
}
