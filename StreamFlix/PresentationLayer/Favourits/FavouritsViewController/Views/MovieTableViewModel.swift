//
//  MovieTableViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 26/07/2025.
//
import Combine

class MovieTableViewModel: RowViewModel {
    
    let favoriteMovieUseCase: FavoriteMovieUseCase?
    let unFavoriteMovieUseCase: UnFavoriteMovieUseCase?
    let cellPressedAction: ((Movie) -> Void)?

    @Published var isFavorite: Bool = true

    let movie: Movie

    init(favoriteMovieUseCase: FavoriteMovieUseCase? = FavoriteMovieUseCaseImpl(),
         unFavoriteMovieUseCase: UnFavoriteMovieUseCase? = UnFavoriteMovieUseCaseImpl(),
         movie: Movie,
         cellPressedAction: ((Movie) -> Void)?) {
        self.favoriteMovieUseCase = favoriteMovieUseCase
        self.unFavoriteMovieUseCase = unFavoriteMovieUseCase
        self.movie = movie
        self.cellPressedAction = cellPressedAction
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

    func cellIdentifier() -> String {
        MovieTableViewCell.identifier
    }
}

extension MovieTableViewModel: CellPressible {
    func cellPressed() {
        self.cellPressedAction?(self.movie)
    }
}
