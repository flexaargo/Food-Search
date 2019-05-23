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
      image: #imageLiteral(resourceName: "onboarding_backup"),
      pageNumber: 3
    )
    denyBtn.isHidden = true
    confirmBtn.addTarget(self, action: #selector(didPressConfirmButton), for: .touchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension OnboardingPageThree {
  @objc func didPressConfirmButton() {
    let emptyAlert = UIAlertController(title: nil, message: "You must input a backup location", preferredStyle: .alert)
    emptyAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    let alertC = UIAlertController(title: "Backup Location", message: "Please provide a backup location", preferredStyle: .alert)
    var textField: UITextField!
    alertC.addTextField { (tf) in
      tf.placeholder = "neighborhood, city, state or zip code"
      tf.autocapitalizationType = .words
      textField = tf
    }
    
    let action = UIAlertAction(title: "Done", style: .default) { (action) in
      if !textField.text!.isEmpty {
        Defaults.saveBackupLocation(locationString: textField.text!)
        self.goToNextOnboardingScreen(next: OnboardingPageFour(), prev: self)
      } else {
        self.present(emptyAlert, animated: true, completion: nil)
      }
    }
    
    alertC.addAction(action)
    
    present(alertC, animated: true, completion: nil)
  }
}
