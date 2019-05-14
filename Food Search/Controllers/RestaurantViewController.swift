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
  
  lazy var scrollView = DetailScrollView()
  
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
    extendedLayoutIncludesOpaqueBars = true
    
    // MARK: - Setup subviews
    view.addSubview(scrollView)
    
    scrollView.anchor(
      top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor
    )
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
      DispatchQueue.main.async {
        self?.assignValues()
      }
    }
  }
  
  func assignValues() {
    scrollView.headerView.detailHeader = DetailHeader(
      name: restaurant.name,
      reviewCount: restaurant.reviewCount,
      rating: restaurant.rating,
      price: restaurant.price,
      categories: restaurant.categories,
      hours: restaurant.hours
    )
  }
}
