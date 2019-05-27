//
//  NearbyViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit
import MapKit

class NearbyViewController: UIViewController {
  
  private let mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
    mapView.isRotateEnabled = false
    return mapView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Map"
    view.backgroundColor = .white
    mapView.delegate = self
    setupSubviews()
  }
}

// MARK: - Private Methods
private extension NearbyViewController {
  func setupSubviews() {
    view.addSubview(mapView)
    
    mapView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor
    )
  }
}

// MARK: - Public Methods
extension NearbyViewController {
  func updateRestaurants(restaurants: [YRestaurantSimple]) {
    if restaurants.count == 0 { return }
    
    mapView.removeAnnotations(mapView.annotations)
    
    for restaurant in restaurants {
      let annotation = RestaurantAnnotation(restaurant: restaurant)
      annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
      mapView.addAnnotation(annotation)
    }
    
    let reference = restaurants.randomElement()!
    
    let region = MKCoordinateRegion(
      center: CLLocationCoordinate2D(latitude: reference.coordinates.latitude, longitude: reference.coordinates.longitude),
      span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    mapView.setRegion(region, animated: false)
  }
}

// MARK: - Map View Delegate Methods
extension NearbyViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let annotation = view.annotation as! RestaurantAnnotation
    let restaurant = annotation.restaurant
    let detailsVC = RestaurantViewController(restaurantId: restaurant.id, name: restaurant.name)
    mapView.deselectAnnotation(annotation, animated: true)
    navigationController?.pushViewController(detailsVC, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    for view in views {
      view.isEnabled = true
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

class RestaurantAnnotation: MKPointAnnotation {
  public var restaurant: YRestaurantSimple
  
  init(restaurant: YRestaurantSimple) {
    self.restaurant = restaurant
    super.init()
  }
}
