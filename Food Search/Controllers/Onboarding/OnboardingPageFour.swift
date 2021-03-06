//
//  OnboardingPageFour.swift
//  Food Search
//
//  Created by Alex Fargo on 5/22/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class OnboardingPageFour: OnboardingBaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  init() {
    super.init(
      titleText: "All Done",
      detailText: "You are now all done setting up!\n\nGo find some food!",
      image: #imageLiteral(resourceName: "onboarding_appicon"),
      pageNumber: 4
    )
    confirmBtn.setTitle("Let's Go", for: .normal)
    denyBtn.isHidden = true
    confirmBtn.addTarget(self, action: #selector(didPressConfirmButton), for: .touchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension OnboardingPageFour {
  @objc func didPressConfirmButton() {
    discoverViewController.onboardingFinished()
    dismissOnboardingScreens()
  }
}
