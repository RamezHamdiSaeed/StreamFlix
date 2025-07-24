//
//  DetailsViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 22/07/2025.
//
import Combine

class DetailsViewModel: BaseViewModel {
    let movie: Movie
    var coordinator: BaseCoordinator?

    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?

    @Published var isFavorite: Bool = false

    init(movie: Movie) {
        self.movie = movie
    }

    func isFavoriteMovie() {
        self.isFavorite = self.isFavoriteMovieUseCase?.isFavoriteMovie(movieTitle: self.movie.title ?? "") ?? false
    }

    func favoriteMovie() {
      let isFavoriteMovieSuccess = self.favoriteMovieUseCase?.favoriteMovie(movieTitle: self.movie.title ?? "")
        if isFavoriteMovieSuccess ?? false {
            self.isFavorite = true
        } else {
            self.isFavorite = false
        }
    }

    func unFavoriteMovie() {
      let isUnFavoriteMovieSuccess = self.unFavoriteMovieUseCase?.unFavoriteMovie(movieTitle: self.movie.title ?? "")
        if isUnFavoriteMovieSuccess ?? false {
            self.isFavorite = false
        } else {
            self.isFavorite = true
        }
    }
}
