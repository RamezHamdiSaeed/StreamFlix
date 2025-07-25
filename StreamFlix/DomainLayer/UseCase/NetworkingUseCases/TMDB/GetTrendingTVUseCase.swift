//
//  GetPopularMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

protocol GetTrendingTVUseCase {
    func getTrendingTV(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetTrendingTVUseCaseImpl: UseCase<Title, APIError>, GetTrendingTVUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    override func execute(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.getTrendingTV { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTrendingTV(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.movieRepository.getTrendingTV { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
