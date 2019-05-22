//
//  FavoritesViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController {
  
  var restaurants: [YRestaurantDetail] = []
  var restaurantIds: [String] = []
  var requests: [AnyObject?] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Favorites"
    view.backgroundColor = .white
    tableView.register(RestaurantCell.self, forCellReuseIdentifier: RestaurantCell.reuseIdentifier)
    tableView.separatorStyle = .none
    extendedLayoutIncludesOpaqueBars = true
    
    fetchAllRestaurants()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if Defaults.getRestaurants().count != restaurantIds.count {
      fetchAllRestaurants()
    }
  }
}

private extension FavoritesViewController {
  func fetchAllRestaurants() {
    getSavedRestaurants()
    let dispatchGroup = DispatchGroup()
    for (i,restaurantId) in restaurantIds.enumerated() {
      dispatchGroup.enter()
      var restaurantDetailResource = RestaurantDetailResource()
      restaurantDetailResource.id = restaurantId
      let restaurantDetailsRequest = YelpApiRequest(resource: restaurantDetailResource)
      requests[i] = restaurantDetailsRequest
      restaurantDetailsRequest.load { [weak self] (restaurant) in
        guard let restaurant = restaurant else {
          print("failed")
          dispatchGroup.leave()
          return
        }
        self?.restaurants.append(restaurant)
        dispatchGroup.leave()
      }
    }
    
    dispatchGroup.notify(queue: .main) {
      self.restaurants.sort(by: { (r1, r2) -> Bool in
        r1.name < r2.name
      })
      self.tableView.reloadData()
    }
  }
  
  func getSavedRestaurants() {
    restaurantIds = Defaults.getRestaurants()
    requests = [AnyObject?](repeating: nil, count: restaurantIds.count)
    restaurants = []
  }
}

extension FavoritesViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return restaurants.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
    
    cell.restaurantDetail = restaurants[indexPath.row]
    
    return cell
  }
}

extension FavoritesViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let restaurant = restaurants[indexPath.row]
    let detailsVC = RestaurantViewController(restaurantId: restaurant.id, name: restaurant.name)
    navigationController?.pushViewController(detailsVC, animated: true)
  }
}
