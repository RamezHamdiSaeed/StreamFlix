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
        let homeViewController = HomeViewController(nibName: "HomeViewController", bundle: nil)
        let searchViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
        let commingSoonViewController = CommingSoonViewController(nibName: "CommingSoonViewController", bundle: nil)
        let downloadsViewController = DownloadsViewController(nibName: "DownloadsViewController", bundle: nil)

        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let commingSoonNavigationController = UINavigationController(rootViewController: commingSoonViewController)
        let downloadsNavigationController = UINavigationController(rootViewController: downloadsViewController)
        
        homeNavigationController.tabBarItem.image = UIImage(systemName: "house")
        searchNavigationController.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        commingSoonNavigationController.tabBarItem.image = UIImage(systemName: "play.circle")
        downloadsNavigationController.tabBarItem.image = UIImage(systemName: "arrow.down")
        
        homeNavigationController.title = "Home"
        searchNavigationController.title = "Search"
        commingSoonNavigationController.title = "Comming Soon"
        downloadsNavigationController.title = "Downloads"
        
        let tabBarNavigationControllers = [homeNavigationController, searchNavigationController, commingSoonNavigationController, downloadsNavigationController]
        
        setViewControllers(tabBarNavigationControllers, animated: true)
    }

}
