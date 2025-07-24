//
//  TabBarController.swift
//  StreamFlix
//
//  Created by Macbook on 23/05/2025.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeViewCoordinator: HomeViewCoordinator = .init()
        let commingSoonCoordinator: CommingSoonViewCoordinator = .init()
        let searchCoordinator: SearchViewCoordinator = .init()
        let favouritsCoordinator: FavouritsViewCoordinator = .init()

        let tabBarNavigationControllers = [homeViewCoordinator.startVC(),
                                           searchCoordinator.startVC(),
                                           commingSoonCoordinator.startVC(),
                                           favouritsCoordinator.startVC()]

        self.tabBar.tintColor = .label

        setViewControllers(tabBarNavigationControllers, animated: true)
    }

}
