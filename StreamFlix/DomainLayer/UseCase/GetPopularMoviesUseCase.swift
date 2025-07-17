//
//  GetPopularMoviesUseCase.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 17/07/2025.
//

protocol GetPopularMoviesUseCase {
    func getPopularMovies(completion: @escaping ((Result<Title, APIError>) -> Void))
}

class GetPopularMoviesUseCaseImpl: GetPopularMoviesUseCase {
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }
    
    func getPopularMovies(completion: @escaping ((Result<Title, APIError>) -> Void)) {
        self.movieRepository.getPopularMovies { result in
            switch result {
            case .success(let title):
                completion(.success(title))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    

}
