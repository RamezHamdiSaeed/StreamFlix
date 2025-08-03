//
//  FavoritsViewModel.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 26/07/2025.
//
import Foundation
import Combine

class MenuViewModel: BaseViewModel {
    let retrieveFavoriteMoviesUseCase: any UseCase

    let coordinator: BaseCoordinator

    var favoriteMovies: [Movie] = []
    @Published var sectionViewModels = [SectionViewModel]()

    init(retrieveFavoriteMoviesUseCase: any UseCase, coordinator: BaseCoordinator) {
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
                } else if let coordinator = self?.coordinator as? CommingSoonViewCoordinator {
                    coordinator.navToVC(presentType: .fullScreen, distination: .movieDetails(movie))
                }
            }))
        }
        return rowViewModels
    }
    
    func retrieveFavoriteMovies() {
        self.retrieveFavoriteMoviesUseCase.execute { [weak self] movies in
            switch movies {
            case .success(let movies):
                if let favoriteMovies = movies as? [Movie] {
                    self?.favoriteMovies = favoriteMovies
                } else if let upCommingMovies = movies as? Title {
                    let movies = upCommingMovies.results
                    self?.favoriteMovies = movies
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        self.buildViewModels()
    }
}
