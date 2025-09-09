//
//  MovieRemoteDataSource.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

protocol MovieRemoteDataSource {
    func getTrendingMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getTrendingTV(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getPopularMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getUpcommingMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getTopRatedMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getSearchMovies(query: String?, completion: @escaping ((Result<Title, APIError>) -> Void))
}

class MovieRemoteDataSourceImpl: MovieRemoteDataSource {

    func getTrendingMovies(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        let apiRequest = GetTrendingMoviesRequest()
        APICaller.shared.networkRequest(apiRequest: apiRequest, responseType: Title.self) { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTrendingTV(completion: @escaping (Result<Title, APIError>) -> Void) {
        let apiRequest = GetTrendingTVRequest()
        APICaller.shared.networkRequest(apiRequest: apiRequest, responseType: Title.self) { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getPopularMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        let apiRequest = GetPopularMoviesRequest()
        APICaller.shared.networkRequest(apiRequest: apiRequest, responseType: Title.self) { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getUpcommingMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        let apiRequest = GetUpcommingMoviesRequest()
        APICaller.shared.networkRequest(apiRequest: apiRequest, responseType: Title.self) { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getTopRatedMovies(completion: @escaping (Result<Title, APIError>) -> Void) {
        let apiRequest = GetTopRatedMoviesRequest()
        APICaller.shared.networkRequest(apiRequest: apiRequest, responseType: Title.self) { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSearchMovies(query: String?, completion: @escaping (Result<Title, APIError>) -> Void) {
        let apiRequest = GetMoviesSearchRequest()
        apiRequest.query = query
        APICaller.shared.networkRequest(apiRequest: apiRequest, responseType: Title.self) { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
