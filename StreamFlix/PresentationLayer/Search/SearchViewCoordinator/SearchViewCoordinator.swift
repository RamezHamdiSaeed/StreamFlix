//
//  SearchViewCoordinator.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 18/07/2025.
//
import UIKit

class SearchViewCoordinator: BaseCoordinator {
    
    var presentType: UIModalPresentationStyle
    
    weak var viewController: UIViewController?
    
    init(presentType: UIModalPresentationStyle = .fullScreen) {
        self.presentType = presentType
    }
    
    func startVC() -> UIViewController {
        let searchViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let searchViewModel = MenuViewModel(retrieveFavoriteMoviesUseCase: GetMoviesSearchUseCaseImpl(), coordinator: self)
        searchViewController.viewModel = searchViewModel
        
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavigationController.title = "Search"
        searchNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        searchNavigationController.modalPresentationStyle = self.presentType

        self.viewController = searchNavigationController
        return searchNavigationController
    }

    func navToVC(presentType: UIModalPresentationStyle, distination: Distination) {
        switch distination {
        case .movieDetails(let movie):
            self.navToMovieDetailsVC(movie: movie, modalPresentationStyle: presentType)
        }
    }

    func navToMovieDetailsVC(movie: Movie, modalPresentationStyle: UIModalPresentationStyle) {
        let movieDetailsScreenCoordinator = DetailsViewCoordinator()

        let movieDetailsVC = movieDetailsScreenCoordinator.startVC(movie: movie)
        movieDetailsVC.modalPresentationStyle = modalPresentationStyle
        if let navigationController = self.viewController as? UINavigationController {
            navigationController.pushViewController(movieDetailsVC, animated: true)
            return
        }
        self.viewController?.present(movieDetailsVC, animated: true)
    }

}

extension SearchViewCoordinator {
    enum Distination {
        case movieDetails(Movie)
    }
}
