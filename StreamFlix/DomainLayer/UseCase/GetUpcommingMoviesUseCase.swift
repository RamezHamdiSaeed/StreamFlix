//
//  GetUpcommingMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 20/07/2025.
//


protocol GetUpcommingMoviesUseCase {
    func getUpcommingMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetUpcommingMoviesUseCaseImpl: UseCase<Title, APIError>, GetUpcommingMoviesUseCase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }
    
    override func execute(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.getUpcommingMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUpcommingMovies(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.movieRepository.getUpcommingMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
