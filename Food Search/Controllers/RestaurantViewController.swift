//
//  RestaurantViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
  
  private var restaurant: YRestaurantDetail!
  private var request: AnyObject?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  init(restaurantId: String) {
    super.init(nibName: nil, bundle: nil)
    fetchRestaurant(withId: restaurantId)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension RestaurantViewController {
  func setup() {
    view.backgroundColor = .white
  }
  
  func fetchRestaurant(withId id: String) {
    var restaurantDetailResource = RestaurantDetailResource()
    restaurantDetailResource.id = id
    let restaurantDetailsRequest = YelpApiRequest(resource: restaurantDetailResource)
    request = restaurantDetailsRequest
    restaurantDetailsRequest.load { [weak self] (restaurant) in
      guard let restaurant = restaurant else {
        print("failed")
        return
      }
      self?.restaurant = restaurant
      print(restaurant.name)
    }
  }
}
