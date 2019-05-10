//
//  DiscoverViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
  
  lazy var searchView: DiscoverSearchView = {
    return DiscoverSearchView(frame: .zero)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Discover"
    view.backgroundColor = .white
    view.addSubview(searchView)
    searchView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 0, right: 0)
    )
  }
}
