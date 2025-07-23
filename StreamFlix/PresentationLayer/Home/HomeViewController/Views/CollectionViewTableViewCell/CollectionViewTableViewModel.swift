//
//  CollectionViewTableViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

class CollectionViewTableViewCellViewModel: RowViewModel {
    let movies: [Movie]
    var sectionViewModels: [SectionViewModel]?
    var collectionViewCellPressedAction: ((Movie) -> ())?
    
    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?

    init( movies: [Movie], collectionViewCellPressedAction: ((Movie) -> ())? = nil) {
        self.movies = movies
        self.collectionViewCellPressedAction = collectionViewCellPressedAction
    }
    
    func buildViewModels() {
        var sectionViewModels = [SectionViewModel]()
        let sectionModel = SectionModel()
        let sectionViewModel = SectionViewModel(sectionModel: sectionModel, rowViewModels: self.getMoviesRowViewModels())
        sectionViewModels.append(sectionViewModel)
        self.sectionViewModels = sectionViewModels
    }
    
    func getMoviesRowViewModels() -> [RowViewModel] {
        var rowViewModels: [RowViewModel] = []
        
        self.movies.forEach {
            let cellViewModel = TitleCollectionViewCellViewModel(movie: $0) { [weak self] movie in
                self?.collectionViewCellPressedAction?(movie)
            }
            
            cellViewModel.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
            cellViewModel.favoriteMovieUseCase = self.favoriteMovieUseCase
            cellViewModel.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase
            
            rowViewModels.append(cellViewModel)
        }
        
        return rowViewModels
    }
    
    
    func cellIdentifier() -> String {
        CollectionViewTableViewCell.identifier
    }
}
