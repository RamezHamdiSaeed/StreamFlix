//
//  MovieTableViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 26/07/2025.
//
import Combine

class MovieTableViewModel: RowViewModel {
    
    let isFavoriteMovieUseCase: IsFavoriteMovieUseCase
    let favoriteMovieUseCase: FavoriteMovieUseCase
    let unFavoriteMovieUseCase: UnFavoriteMovieUseCase
    let cellPressedAction: ((Movie) -> Void)?

    @Published var isFavorite: Bool = true

    let movie: Movie

    init(isFavoriteMovieUseCase: IsFavoriteMovieUseCase = IsFavoriteMovieUseCaseImpl(),
         favoriteMovieUseCase: FavoriteMovieUseCase = FavoriteMovieUseCaseImpl(),
         unFavoriteMovieUseCase: UnFavoriteMovieUseCase = UnFavoriteMovieUseCaseImpl(),
         movie: Movie,
         cellPressedAction: ((Movie) -> Void)?) {
        self.isFavoriteMovieUseCase = isFavoriteMovieUseCase
        self.favoriteMovieUseCase = favoriteMovieUseCase
        self.unFavoriteMovieUseCase = unFavoriteMovieUseCase
        self.movie = movie
        self.cellPressedAction = cellPressedAction
    }

    func isFavoriteMovie() {
        self.isFavorite = self.isFavoriteMovieUseCase.isFavoriteMovie(movieTitle: self.movie.title ?? "")
    }
    
    func favoriteMovie() {
        let isFavoriteMovieSuccess = self.favoriteMovieUseCase.favoriteMovie(movieTitle: self.movie.title ?? "")
        if isFavoriteMovieSuccess {
            self.isFavorite = true
        } else {
            self.isFavorite = false
        }
    }

    func unFavoriteMovie() {
        let isUnFavoriteMovieSuccess = self.unFavoriteMovieUseCase.unFavoriteMovie(movieTitle: self.movie.title ?? "")
        if isUnFavoriteMovieSuccess {
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
