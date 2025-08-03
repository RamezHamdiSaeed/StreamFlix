//
//  CommingSoonViewCoordinator.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 18/07/2025.
//
import UIKit

class CommingSoonViewCoordinator: BaseCoordinator {
    var presentType: UIModalPresentationStyle

    weak var viewController: UIViewController?

    init(presentType: UIModalPresentationStyle = .fullScreen) {
        self.presentType = presentType
    }

    func startVC() -> UIViewController {
        let commingSoonViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        let favoritsViewModel = MenuViewModel(retrieveFavoriteMoviesUseCase: GetUpcommingMoviesUseCaseImpl(), coordinator: self)

        commingSoonViewController.viewModel = favoritsViewModel

        let commingSoonNavigationController = UINavigationController(rootViewController: commingSoonViewController)
        commingSoonNavigationController.title = "Comming Soon"
        commingSoonNavigationController.tabBarItem.image = UIImage(systemName: "play.circle")
        commingSoonNavigationController.modalPresentationStyle = self.presentType

        self.viewController = commingSoonNavigationController
        return commingSoonNavigationController
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

extension CommingSoonViewCoordinator {
    enum Distination {
        case movieDetails(Movie)
    }
}


