//
//  MovieRemoteDataSource.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

protocol MovieRemoteDataSource {
    func getPopularMoviesRequest(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class MovieRemoteDataSourceImpl: MovieRemoteDataSource {
    func getPopularMoviesRequest(completion: @escaping ((Result<Title, APIError>) -> Void)) {
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
}
