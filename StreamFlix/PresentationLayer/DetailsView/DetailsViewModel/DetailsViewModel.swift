//
//  DetailsViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 22/07/2025.
//

class DetailsViewModel: BaseViewModel {
    let movie: Movie
    var coordinator: BaseCoordinator?
    
    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?
    
    var isFavorite = Observable<Bool>(value: false)
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func isFavoriteMovie() {
        self.isFavorite.value = self.isFavoriteMovieUseCase?.isFavoriteMovie(movieTitle: self.movie.title ?? "") ?? false
    }
    
    func favoriteMovie() {
      let isFavoriteMovieSuccess = self.favoriteMovieUseCase?.favoriteMovie(movieTitle: self.movie.title ?? "")
        if isFavoriteMovieSuccess ?? false {
            self.isFavorite.value = true
        } else {
            self.isFavorite.value = false
        }
    }
    
    func unFavoriteMovie() {
      let isUnFavoriteMovieSuccess = self.unFavoriteMovieUseCase?.unFavoriteMovie(movieTitle: self.movie.title ?? "")
        if isUnFavoriteMovieSuccess ?? false {
            self.isFavorite.value = false
        } else {
            self.isFavorite.value = true
        }
    }
}
