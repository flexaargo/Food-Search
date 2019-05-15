//
//  DetailScrollView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/13/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DetailScrollView: UIScrollView {
  
  lazy var headerView: DetailHeaderView = {
    return DetailHeaderView(frame: .zero)
  }()
  
  lazy var mapView: DetailMapView = {
    return DetailMapView(frame: .zero)
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentSize = CGSize(width: frame.width, height: 1000)
    delaysContentTouches = false
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension DetailScrollView {
  func setupSubviews() {
    addSubview(headerView)
    addSubview(mapView)
    
    headerView.anchor(
      top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: mapView.topAnchor, trailing: safeAreaLayoutGuide.trailingAnchor
    )
    
    mapView.anchor(
      top: headerView.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor
    )
  }
}
