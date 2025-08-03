//
//  FavouritsViewCoordinator.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 18/07/2025.
//
import UIKit

class FavouritsViewCoordinator: BaseCoordinator {
    var presentType: UIModalPresentationStyle

    weak var viewController: UIViewController?

    init(presentType: UIModalPresentationStyle = .fullScreen) {
        self.presentType = presentType
    }

    func startVC() -> UIViewController {
        let favouritsViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let favoritsViewModel = MenuViewModel(retrieveFavoriteMoviesUseCase: RetrieveFavoriteMoviesUseCaseImpl(), coordinator: self)

        favouritsViewController.viewModel = favoritsViewModel

        let favouritsNavigationController = UINavigationController(rootViewController: favouritsViewController)
        favouritsNavigationController.title = "Favourites"
        favouritsNavigationController.tabBarItem.image = UIImage(systemName: "heart.fill")
        favouritsNavigationController.modalPresentationStyle = self.presentType

        self.viewController = favouritsNavigationController
        return favouritsNavigationController
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

extension FavouritsViewCoordinator {
    enum Distination {
        case movieDetails(Movie)
    }
}
