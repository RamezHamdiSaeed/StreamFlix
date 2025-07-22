//
//  DetailsViewCoordinator.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 22/07/2025.
//
import UIKit
class DetailsViewCoordinator: BaseCoordinator {
    var presentType: UIModalPresentationStyle
    
    weak var viewController: UIViewController?
    
    init(presentType: UIModalPresentationStyle = .fullScreen, viewController: UIViewController? = nil) {
        self.presentType = presentType
        self.viewController = viewController
    }
    
    func startVC(movie: Movie) -> UIViewController {
        let viewModel = DetailsViewModel(movie: movie)
        viewModel.coordinator = self
        viewModel.favoriteMovie = UseCase()
        viewModel.unFavoriteMovie = UseCase()
        let detailsViewController = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        detailsViewController.viewModel = viewModel
        self.viewController = detailsViewController
        return detailsViewController
    }
    
}
