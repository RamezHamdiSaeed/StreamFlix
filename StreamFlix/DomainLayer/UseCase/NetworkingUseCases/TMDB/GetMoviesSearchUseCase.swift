//
//  GetMoviesSearchUseCase.swift
//  StreamFlix
//
//  Created by ramez Hamdy on 04/08/2025.
//
import Foundation

protocol GetMoviesSearchUseCase {
    func getSearchMovies(query: String?, completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetMoviesSearchUseCaseImpl: GetMoviesSearchUseCase, UseCase {
    
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }
    
    func getSearchMovies(query: String?, completion: @escaping (Result<Title, APIError>) -> Void) {
        self.movieRepository.getSearchMovies(query: query) { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func execute(completion: @escaping (Result<Any, any Error>) -> Void) {
        self.getSearchMovies(query: "A") { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
