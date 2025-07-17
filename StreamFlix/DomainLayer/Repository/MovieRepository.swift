//
//  MovieProtocol.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

protocol MovieRepository {
    func getPopularMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}
