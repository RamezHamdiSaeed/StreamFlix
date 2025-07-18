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
    
    init(presentType: UIModalPresentationStyle = .fullScreen) {
        self.presentType = presentType
    }
    
    func startVC() -> UIViewController {
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let homeViewModel = HomeViewModel(coordinator: self)
        homeViewController.viewModel = homeViewModel
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.title = "Home"
        homeNavigationController.tabBarItem.image = UIImage(systemName: "house")
        homeNavigationController.modalPresentationStyle = presentType
        
        self.viewController = homeNavigationController
        return homeNavigationController
    }
    
    func navToVC(presentType: UIModalPresentationStyle, distination: BaseViewController) {
        
    }
    
    
}
