//
//  TitleCollectionViewCellViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

class TitleCollectionViewCellViewModel: RowViewModel {
    let movie: Movie
    var cellPressedAction: ((Movie) -> ())?
    var isFavorite = Observable<Bool>(value: false)
    
    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?
    
    init(movie: Movie, collectionViewCellPressedAction: ((Movie) -> ())? = nil) {
        self.movie = movie
        self.cellPressedAction = collectionViewCellPressedAction
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
    
    func cellIdentifier() -> String {
        TitleCollectionViewCell.identifier
    }
}

extension TitleCollectionViewCellViewModel: CellPressible {
    func cellPressed() {
        self.cellPressedAction?(self.movie)
    }
}

