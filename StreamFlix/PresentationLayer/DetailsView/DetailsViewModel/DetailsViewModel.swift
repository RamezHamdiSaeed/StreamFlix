//
//  DetailsViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 22/07/2025.
//

class DetailsViewModel: BaseViewModel {
    let movie: Movie
    var coordinator: BaseCoordinator?
    var favoriteMovie: UseCase<Bool, Error>?
    var unFavoriteMovie: UseCase<Bool, Error>?
    
    init(movie: Movie) {
        self.movie = movie
    }
}
