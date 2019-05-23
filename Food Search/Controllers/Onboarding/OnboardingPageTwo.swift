//
//  OnboardingPageTwo.swift
//  Food Search
//
//  Created by Alex Fargo on 5/22/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit
import CoreLocation

class OnboardingPageTwo: OnboardingBaseViewController {
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
  }
  
  init() {
    super.init(
      titleText: "Restaurants Near You",
      detailText: "In order to get the best experience from Food Search, we need your location to recommend restaurants near you.",
      image: #imageLiteral(resourceName: "onboarding_pin"),
      pageNumber: 2
    )
    confirmBtn.addTarget(self, action: #selector(didPressConfirmButton), for: .touchUpInside)
    denyBtn.addTarget(self, action: #selector(didPressDenyButton), for: .touchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Methods
private extension OnboardingPageTwo {
  @objc func didPressConfirmButton() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  @objc func didPressDenyButton() {
    goToNextOnboardingScreen(next: OnboardingPageThree(), prev: self)
  }
}

extension OnboardingPageTwo: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status != .notDetermined {
      goToNextOnboardingScreen(next: OnboardingPageThree(), prev: self)
    }
  }
}
