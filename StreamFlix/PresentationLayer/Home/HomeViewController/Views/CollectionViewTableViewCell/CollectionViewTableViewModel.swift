//
//  CollectionViewTableViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 19/07/2025.
//

class CollectionViewTableViewCellViewModel: RowViewModel {
    let getMoviesUseCase: UseCase<Title>
    let movies: [Movie]
    var sectionViewModels: [SectionViewModel]?
    let updateMovies: (Title) -> Void
    let updateLoadingStatus: (Bool) -> Void
    var isLoading: Bool
    
    init( movies: [Movie], getMoviesUseCase: UseCase<Title>, isLoading: Bool, updateMovies: @escaping (Title) -> Void, updateLoadingStatus: @escaping (Bool) -> Void) {
        self.movies = movies
        self.getMoviesUseCase = getMoviesUseCase
        self.isLoading = isLoading
        self.updateMovies = updateMovies
        self.updateLoadingStatus = updateLoadingStatus
        if movies.isEmpty {
            self.fetchPopularMovies()
        }
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
            rowViewModels.append(TitleCollectionViewCellViewModel(movie: $0))
        }
        
        return rowViewModels
    }
    
    
    func cellIdentifier() -> String {
        CollectionViewTableViewCell.identifier
    }
    
    
    func fetchPopularMovies() {
        if !self.isLoading {
            self.updateLoadingStatus(true)
            try! self.getMoviesUseCase.execute { [weak self] result in
                self?.updateLoadingStatus(false)
                 switch result {
                 case .success(let title):
                     self?.updateMovies(title)
                 case .failure(let error):
                     print("Error fetching popular movies: \(error)")
                 }
             }
        }
    }
}
