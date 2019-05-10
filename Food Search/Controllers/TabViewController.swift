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
    
    let discoverVC = BaseNavigationController(rootViewController: DiscoverViewController())
    discoverVC.tabBarItem = UITabBarItem(title: "Discover", image: #imageLiteral(resourceName: "stars_unselected"), tag: 0)
    let nearbyVC = BaseNavigationController(rootViewController: NearbyViewController())
    nearbyVC.tabBarItem = UITabBarItem(title: "Nearby", image: #imageLiteral(resourceName: "map_unselected"), tag: 1)
    let favoritesVC = BaseNavigationController(rootViewController: FavoritesViewController())
    favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: #imageLiteral(resourceName: "star_unselected"), tag: 2)
    
    viewControllers = [discoverVC, nearbyVC, favoritesVC]
    tabBar.tintColor = .red
  }
}
