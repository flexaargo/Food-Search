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
  
  let mapView = MKMapView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Map"
    view.backgroundColor = .white
    setupSubviews()
  }
}

private extension NearbyViewController {
  func setupSubviews() {
    view.addSubview(mapView)
    
    mapView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor
    )
  }
}
