//
//  GetTrendingMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

protocol GetTrendingMoviesUseCase {
    func getTrendingMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetTrendingMoviesUseCaseImpl: GetTrendingMoviesUseCase, UseCase {

    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

     func execute(completion: @escaping (Result<Any, any Error>) -> Void) {
        self.getTrendingMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTrendingMovies(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.movieRepository.getTrendingMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
