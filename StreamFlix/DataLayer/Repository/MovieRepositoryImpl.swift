//
//  MovieRepositoryImpl.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

class MovieRepositoryImpl: MovieRepository {
    let movieRemoteDataSource: MovieRemoteDataSource
    let movieLocalDataSource: MovieLocalDataSource
    
    init(movieRemoteDataSource: MovieRemoteDataSource = MovieRemoteDataSourceImpl(), movieLocalDataSource: MovieLocalDataSource = MovieLocalDataSourceImpl()) {
        self.movieRemoteDataSource = movieRemoteDataSource
        self.movieLocalDataSource = movieLocalDataSource
    }
    // MARK: Remote (Networking)
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

// MARK: Local DB
extension MovieRepositoryImpl {
    func isFavoriteMovie(movieTitle: String) -> Bool {
        self.movieLocalDataSource.isFavoriteMovie(movieTitle: movieTitle)
    }
    
    func favoriteMovie(movieTitle: String) -> Bool {
        self.movieLocalDataSource.favoriteMovie(movieTitle: movieTitle)
    }
    
    func unFavoriteMovie(movieTitle: String) -> Bool {
        self.movieLocalDataSource.unFavoriteMovie(movieTitle: movieTitle)
    }
    
    func insertMoviesBySection(movies: [Movie], sectionName: String) {
        self.movieLocalDataSource.insertMoviesBySection(movies: movies, sectionName: sectionName)
    }
    
    func retrieveMoviesBySection(sectionName: String) -> [Movie] {
        self.movieLocalDataSource.retrieveMoviesBySection(sectionName: sectionName)
    }
    

}
