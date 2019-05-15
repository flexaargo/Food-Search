//
//  RestaurantViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

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
    navigationItem.largeTitleDisplayMode = .never
    
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
    
    scrollView.mapView.location = restaurant.coordinates
    scrollView.mapView.mapView.delegate = self
    
    scrollView.imageView.sd_setImage(with: URL(string: restaurant.imageURL)!, completed: nil)
  }
}

extension RestaurantViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    for view in views {
      view.isEnabled = false
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if !(annotation is MKPointAnnotation) {
      return nil
    }
    
    let annotationIdentifier = "pin"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
    
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
      annotationView!.canShowCallout = true
    } else {
      annotationView!.annotation = annotation
    }
    
    let pinImage = UIImage(named: "pin.png")
    annotationView!.image = pinImage
    annotationView!.centerOffset = .init(x: 0, y: -annotationView!.frame.height/2)
    
    return annotationView
  }
}
