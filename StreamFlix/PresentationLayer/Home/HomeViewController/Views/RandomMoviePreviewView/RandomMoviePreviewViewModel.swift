//
//  RandomMoviePreviewViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 20/07/2025.
//
import Foundation

class RandomMoviePreviewViewModel: RowViewModel {

    let randomMovie: Movie
    
    init(randomMovie: Movie) {
        self.randomMovie = randomMovie
    }
    
    func cellIdentifier() -> String {
        RandomMoviePreviewViewCell.identifier
    }
    
}
