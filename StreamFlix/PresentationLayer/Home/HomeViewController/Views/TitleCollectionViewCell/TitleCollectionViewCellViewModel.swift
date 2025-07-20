//
//  TitleCollectionViewCellViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

class TitleCollectionViewCellViewModel: RowViewModel {
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func cellIdentifier() -> String {
        TitleCollectionViewCell.identifier
    }
}
