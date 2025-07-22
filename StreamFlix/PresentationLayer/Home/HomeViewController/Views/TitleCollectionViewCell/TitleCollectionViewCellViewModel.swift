//
//  TitleCollectionViewCellViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

class TitleCollectionViewCellViewModel: RowViewModel {
    let movie: Movie
    var cellPressedAction: ((Movie) -> ())?
    
    init(movie: Movie, collectionViewCellPressedAction: ((Movie) -> ())? = nil) {
        self.movie = movie
        self.cellPressedAction = collectionViewCellPressedAction
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

