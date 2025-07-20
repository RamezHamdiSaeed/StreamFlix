//
//  MovieProtocol.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

protocol MovieRepository {
    func getTrendingMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getTrendingTV(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getPopularMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getUpcommingMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
    func getTopRatedMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}
