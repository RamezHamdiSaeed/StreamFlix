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
        let searchViewController = UIViewController(nibName: "SearchViewController", bundle: nil)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        searchNavigationController.title = "Search"
        searchNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        self.viewController = searchNavigationController
        self.viewController?.modalPresentationStyle = presentType
        return searchNavigationController
    }
    
    func navToVC(presentType: UIModalPresentationStyle, distination: BaseViewController) {
        
    }
    
    
}
