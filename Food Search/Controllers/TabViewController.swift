//
//  TabViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nearbyVC = NearbyViewController()
    let discoverVC = DiscoverViewController(nearbyVC: nearbyVC)
    
    let discoverNavVC = BaseNavigationController(rootViewController: discoverVC)
    discoverNavVC.tabBarItem = UITabBarItem(title: "Discover", image: #imageLiteral(resourceName: "stars_unselected"), tag: 0)
    let nearbyNavVC = BaseNavigationController(rootViewController: nearbyVC)
    nearbyNavVC.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map_unselected"), tag: 1)
    let favoritesNavVC = BaseNavigationController(rootViewController: FavoritesViewController())
    favoritesNavVC.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "star_unselected"), tag: 2)
    
    viewControllers = [discoverNavVC, nearbyNavVC, favoritesNavVC]
    tabBar.tintColor = .red
  }
}
