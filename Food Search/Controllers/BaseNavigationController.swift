//
//  SimpleNavigationController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.prefersLargeTitles = true
    navigationBar.barTintColor = .primaryRed
    navigationBar.barStyle = .black
    navigationBar.tintColor = .white
    navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    navigationBar.isTranslucent = false
    navigationBar.isOpaque = true
    view.backgroundColor = .white
  }
}
