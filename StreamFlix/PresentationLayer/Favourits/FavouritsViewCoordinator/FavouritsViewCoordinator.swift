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
        let favouritsViewController = UIViewController(nibName: "FavouritsViewController", bundle: nil)
        let favouritsNavigationController = UINavigationController(rootViewController: favouritsViewController)
        favouritsNavigationController.title = "Favourites"
        favouritsNavigationController.tabBarItem.image = UIImage(systemName: "heart.fill")
        favouritsNavigationController.modalPresentationStyle = self.presentType
        self.viewController = favouritsNavigationController
        return favouritsNavigationController
    }
    
    func navToVC(presentType: UIModalPresentationStyle, distination: BaseViewController) {
        
    }
    
    
}
