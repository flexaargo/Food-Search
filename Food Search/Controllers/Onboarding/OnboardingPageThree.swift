//
//  OnboardingPageThree.swift
//  Food Search
//
//  Created by Alex Fargo on 5/22/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class OnboardingPageThree: OnboardingBaseViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  init() {
    super.init(
      titleText: "Backup Location",
      detailText: "In case we cannot access your location, please provide a backup location that you would like us to use.",
      image: #imageLiteral(resourceName: "onboarding_backup")
    )
    denyBtn.isHidden = true
    confirmBtn.addTarget(self, action: #selector(didPressConfirmButton), for: .touchUpInside)
    initialVC = self
//    modalPresentationStyle = .overFullScreen
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension OnboardingPageThree {
  @objc func didPressConfirmButton() {
    goToNextOnboardingScreen(next: OnboardingPageFour(), prev: self)
  }
}
