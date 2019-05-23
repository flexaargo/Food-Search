//
//  OnboardingPageTwo.swift
//  Food Search
//
//  Created by Alex Fargo on 5/22/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class OnboardingPageTwo: OnboardingBaseViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  init() {
    super.init(
      titleText: "Restaurants Near You",
      detailText: "In order to get the best experience from Food Search, we need your location to recommend restaurants near you."
    )
    imageView.image = #imageLiteral(resourceName: "onboarding_pin")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
