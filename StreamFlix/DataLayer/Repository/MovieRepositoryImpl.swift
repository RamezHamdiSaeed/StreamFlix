//
//  MovieRepositoryImpl.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

class MovieRepositoryImpl: MovieRepository {

    let movieRemoteDataSource: MovieRemoteDataSource
    
    init(movieRemoteDataSource: MovieRemoteDataSource = MovieRemoteDataSourceImpl()) {
        self.movieRemoteDataSource = movieRemoteDataSource
    }
    func getTrendingMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        self.movieRemoteDataSource.getTrendingMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTrendingTV(completion: @escaping (Result<Title, APIError>) -> Void) {
        self.movieRemoteDataSource.getTrendingTV { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPopularMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        self.movieRemoteDataSource.getPopularMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getUpcommingMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        self.movieRemoteDataSource.getUpcommingMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTopRatedMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        self.movieRemoteDataSource.getTopRatedMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
   
    
}
