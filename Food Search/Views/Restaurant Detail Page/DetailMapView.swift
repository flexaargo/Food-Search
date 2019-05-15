//
//  DetailsMapView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/14/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit
import MapKit

class DetailMapView: UIView {
  var location: Coordinates! {
    didSet {
      let coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
      let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
      mapView.region = region
      
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      mapView.addAnnotation(annotation)
    }
  }
  
  let mapView: MKMapView = {
    let map = MKMapView()
    map.isScrollEnabled = false
    map.isZoomEnabled = false
    map.isPitchEnabled = false
    map.isRotateEnabled = false
    return map
  }()
  
  let getDirectionsBtn: UIButton = {
    let button = UIButton(
      text: "Get Directions",
      font: .systemFont(ofSize: 14, weight: .regular),
      textColor: .white,
      backgroundColor: .primaryRed,
      cornerRadius: 13
    )
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .orange
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension DetailMapView {
  func setupSubviews() {
    addSubview(mapView)
    mapView.addSubview(getDirectionsBtn)
    
    mapView.anchor(
      top: topAnchor, leading: leadingAnchor,
      bottom: bottomAnchor, trailing: trailingAnchor
    )
    mapView.constrainHeight(constant: 200)
    
    getDirectionsBtn.centerXInSuperview()
    getDirectionsBtn.constrainWidth(constant: 110)
    getDirectionsBtn.constrainHeight(constant: 26)
    getDirectionsBtn.anchor(
      top: nil, leading: nil,
      bottom: mapView.bottomAnchor, trailing: nil,
      padding: .init(top: 0, left: 0, bottom: 8, right: 0)
    )
  }
}
