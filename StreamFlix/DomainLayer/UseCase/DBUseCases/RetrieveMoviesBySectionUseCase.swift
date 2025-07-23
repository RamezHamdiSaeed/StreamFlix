//
//  RetrieveMoviesBySection.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 23/07/2025.
//

protocol RetrieveMoviesBySectionUseCase {
    func retrieveMoviesBySection(sectionName: String) -> [Movie]
}

class RetrieveMoviesBySectionUseCaseImpl: RetrieveMoviesBySectionUseCase {
    
    let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository = MovieRepositoryImpl()) {
        self.movieRepository = movieRepository
    }

    func retrieveMoviesBySection(sectionName: String) -> [Movie] {
        self.movieRepository.retrieveMoviesBySection(sectionName: sectionName)
    }
}
