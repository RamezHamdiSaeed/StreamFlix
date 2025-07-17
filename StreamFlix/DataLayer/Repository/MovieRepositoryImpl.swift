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
    func getPopularMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        self.movieRemoteDataSource.getPopularMoviesRequest { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
