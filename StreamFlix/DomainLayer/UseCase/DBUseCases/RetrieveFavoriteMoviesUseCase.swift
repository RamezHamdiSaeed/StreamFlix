//
//  RetrieveFavoriteMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 26/07/2025.
//

protocol RetrieveFavoriteMoviesUseCase {
    func retrieveFavoriteMovies() -> [Movie]
}

class RetrieveFavoriteMoviesUseCaseImpl: RetrieveFavoriteMoviesUseCase, UseCase {
    
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }
    
    func retrieveFavoriteMovies() -> [Movie] {
        self.movieRepository.retrieveFavoriteMovies()
    }
    
    func execute(completion: @escaping (Result<Any, any Error>) -> Void) {
        let movies = self.retrieveFavoriteMovies()
        completion(.success(movies))
    }
}
