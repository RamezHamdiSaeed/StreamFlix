//
//  CommingSoonViewCoordinator.swift
//  StreamFlix
//
//  Created by Ramez Hamdy on 18/07/2025.
//
import Foundation
import UIKit

class CommingSoonViewCoordinator: BaseCoordinator {
    var presentType: UIModalPresentationStyle
    
    weak var viewController: UIViewController?
    
    init(presentType: UIModalPresentationStyle = .fullScreen) {
        self.presentType = presentType
    }
    
    func startVC() -> UIViewController {
        let commingSoonViewController = UIViewController(nibName: "CommingSoonViewController", bundle: nil)
        let commingSoonNavigationController = UINavigationController(rootViewController: commingSoonViewController)
        commingSoonNavigationController.title = "Comming Soon"
        commingSoonNavigationController.tabBarItem.image = UIImage(systemName: "play.circle")
        commingSoonNavigationController.modalPresentationStyle = self.presentType
        self.viewController = commingSoonNavigationController
        return commingSoonNavigationController
    }
    
    func navToVC(presentType: UIModalPresentationStyle, distination: BaseViewController) {
        
    }
    
    
}
