//
//  GetPopularMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 20/07/2025.
//

protocol GetPopularMoviesUseCase {
    func getPopularMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetPopularMoviesUseCaseImpl: UseCase<Title, APIError>, GetPopularMoviesUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    override func execute(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.getPopularMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPopularMovies(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.movieRepository.getPopularMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
