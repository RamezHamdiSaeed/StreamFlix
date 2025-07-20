//
//  GetTrendingMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

protocol GetTrendingMoviesUseCase {
    func getTrendingMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetTrendingMoviesUseCaseImpl: UseCase<Title>, GetTrendingMoviesUseCase {
    
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    override func execute(completion: @escaping (Result<Title, APIError>) -> Void) {
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
