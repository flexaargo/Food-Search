//
//  OnboardingPageOne.swift
//  Food Search
//
//  Created by Alex Fargo on 5/22/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class OnboardingPageOne: OnboardingBaseViewController {
  let nextBtn: UIButton = {
    let button = UIButton(
      text: "Next",
      font: .systemFont(ofSize: 20, weight: .medium),
      textColor: .white
    )
    button.addTarget(self, action: #selector(didPressNext), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubviews()
  }
  
  init() {
    super.init(
      titleText: "Welcome to Food Search",
      detailText: "Before you can get started, there are a few things we need from you...",
      pageNumber: 1
    )
    confirmBtn.isHidden = true
    denyBtn.isHidden = true
    imageView.isHidden = true
    initialVC = self
    modalPresentationStyle = .overFullScreen
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension OnboardingPageOne {
  func setupSubviews() {
    view.addSubview(nextBtn)
    
    nextBtn.anchor(
      top: nil, leading: nil,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 16, right: 32)
    )
  }
  
  @objc func didPressNext() {
    goToNextOnboardingScreen(next: OnboardingPageTwo(), prev: self)
  }
}
