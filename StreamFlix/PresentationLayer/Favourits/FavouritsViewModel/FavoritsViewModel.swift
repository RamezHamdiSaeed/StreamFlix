//
//  FavoritsViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 26/07/2025.
//
import Foundation
import Combine

class FavoritsViewModel: BaseViewModel {
    let retrieveFavoriteMoviesUseCase: RetrieveFavoriteMoviesUseCase

    let coordinator: BaseCoordinator

    var favoriteMovies: [Movie] = []
    @Published var sectionViewModels = [SectionViewModel]()

    init(retrieveFavoriteMoviesUseCase: RetrieveFavoriteMoviesUseCase, coordinator: BaseCoordinator) {
        self.retrieveFavoriteMoviesUseCase = retrieveFavoriteMoviesUseCase
        self.coordinator = coordinator
    }

    func buildViewModels() {
        var sectionViewModels = [SectionViewModel]()

        if !favoriteMovies.isEmpty {
            let favoritSectionModel = SectionModel(headerTitle: "Favorits", headerHeight: 100)
            let favoritsSectionViewModel = SectionViewModel(sectionModel: favoritSectionModel, rowViewModels: self.getFavoritsRowViewModel())
            
            sectionViewModels.append(favoritsSectionViewModel)
        }
        self.sectionViewModels = sectionViewModels
    }

    func getFavoritsRowViewModel() -> [RowViewModel] {
        var rowViewModels: [RowViewModel] = []
        self.favoriteMovies.forEach { movie in
            rowViewModels.append(MovieTableViewModel(movie: movie, cellPressedAction: { [weak self] movie in
                    if let coordinator = self?.coordinator as? FavouritsViewCoordinator {
                        coordinator.navToVC(presentType: .fullScreen, distination: .movieDetails(movie))
                }
            }))
        }
        return rowViewModels
    }
    
    func retrieveFavoriteMovies() {
        self.favoriteMovies =  self.retrieveFavoriteMoviesUseCase.retrieveFavoriteMovies()
        self.buildViewModels()
    }
}
