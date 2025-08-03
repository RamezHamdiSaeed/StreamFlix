//
//  GetTopRatedMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 20/07/2025.
//

protocol GetTopRatedMoviesUseCase {
    func getTopRatedMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetTopRatedMoviesUseCaseImpl: GetTopRatedMoviesUseCase, UseCase {
    
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    func execute(completion: @escaping ((Result<Any, any Error>) -> Void)) {
        self.getTopRatedMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTopRatedMovies(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.movieRepository.getTopRatedMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
