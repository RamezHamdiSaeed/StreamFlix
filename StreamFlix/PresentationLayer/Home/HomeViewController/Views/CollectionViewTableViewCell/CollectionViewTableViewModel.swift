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
            rowViewModels.append(TitleCollectionViewCellViewModel(movie: $0) { [weak self] movie in
                self?.collectionViewCellPressedAction?(movie)
            })
        }
        
        return rowViewModels
    }
    
    
    func cellIdentifier() -> String {
        CollectionViewTableViewCell.identifier
    }
}
