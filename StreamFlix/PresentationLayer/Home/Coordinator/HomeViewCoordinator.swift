//
//  HomeCoordinator.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 18/07/2025.
//
import Foundation
import UIKit

class HomeViewCoordinator: BaseCoordinator {
    
    var presentType: UIModalPresentationStyle
    
    weak var viewController: UIViewController?
    
    // MARK: reusable UseCases between multiple screens or viewControllers
    var isFavoriteMovieUseCase: IsFavoriteMovieUseCase?
    var favoriteMovieUseCase: FavoriteMovieUseCase?
    var unFavoriteMovieUseCase: UnFavoriteMovieUseCase?
    var insertMoviesBySectionUseCase: InsertMoviesBySectionUseCase?
    var retrieveMoviesBySectionUseCase: RetrieveMoviesBySectionUseCase?
    
    init(presentType: UIModalPresentationStyle = .fullScreen) {
        self.presentType = presentType
    }
    
    func startVC() -> UIViewController {
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let homeViewModel = HomeViewModel(coordinator: self)
        
        self.isFavoriteMovieUseCase = IsFavoriteMovieUseCaseImpl()
        self.favoriteMovieUseCase = FavoriteMovieUseCaseImpl()
        self.unFavoriteMovieUseCase = UnFavoriteMovieUseCaseImpl()
        self.insertMoviesBySectionUseCase = InsertMoviesBySectionUseCaseImpl()
        self.retrieveMoviesBySectionUseCase = RetrieveMoviesBySectionUseCaseImpl()
        
        homeViewModel.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
        homeViewModel.favoriteMovieUseCase = self.favoriteMovieUseCase
        homeViewModel.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase
        homeViewModel.insertMoviesBySectionUseCase = self.insertMoviesBySectionUseCase
        homeViewModel.retrieveMoviesBySectionUseCase = self.retrieveMoviesBySectionUseCase
        
        homeViewController.viewModel = homeViewModel
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.title = "Home"
        homeNavigationController.tabBarItem.image = UIImage(systemName: "house")
        homeNavigationController.modalPresentationStyle = presentType
        
        self.viewController = homeNavigationController
        return homeNavigationController
    }
    
    func navToVC(presentType: UIModalPresentationStyle, distination: Distination) {
        switch distination{
        case .movieDetails(let movie, let modalPresentationStyle):
            self.navToMovieDetailsVC(movie: movie, modalPresentationStyle: modalPresentationStyle)
        }
    }
    
    func navToMovieDetailsVC(movie: Movie, modalPresentationStyle: UIModalPresentationStyle) {
        let movieDetailsScreenCoordinator = DetailsViewCoordinator()
        
        movieDetailsScreenCoordinator.isFavoriteMovieUseCase = self.isFavoriteMovieUseCase
        movieDetailsScreenCoordinator.favoriteMovieUseCase = self.favoriteMovieUseCase
        movieDetailsScreenCoordinator.unFavoriteMovieUseCase = self.unFavoriteMovieUseCase
        
        let movieDetailsVC = movieDetailsScreenCoordinator.startVC(movie: movie)
        movieDetailsVC.modalPresentationStyle = modalPresentationStyle
        if let navigationController = self.viewController as? UINavigationController {
            navigationController.pushViewController(movieDetailsVC, animated: true)
            return
        }
        self.viewController?.present(movieDetailsVC, animated: true)
    }
}

extension HomeViewCoordinator {
    enum Distination {
        case movieDetails(Movie,UIModalPresentationStyle)
    }
}
