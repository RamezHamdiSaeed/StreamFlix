//
//  TitleCollectionViewCellViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//
import Combine

class TitleCollectionViewCellViewModel: RowViewModel {
    let movie: Movie
    var cellPressedAction: ((Movie) -> ())?
//    var isFavorite = Observable<Bool>(value: false)
   @Published var isFavorite = false
    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?
    
    init(movie: Movie, collectionViewCellPressedAction: ((Movie) -> ())? = nil) {
        self.movie = movie
        self.cellPressedAction = collectionViewCellPressedAction
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
    
    func cellIdentifier() -> String {
        TitleCollectionViewCell.identifier
    }
}

extension TitleCollectionViewCellViewModel: CellPressible {
    func cellPressed() {
        self.cellPressedAction?(self.movie)
    }
}

