//
//  OnboardingBaseViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/22/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class OnboardingBaseViewController: UIViewController {
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  let image: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .clear
    return image
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel(
      font: .systemFont(ofSize: 24, weight: .bold),
      textColor: .white
    )
    label.textAlignment = .center
    return label
  }()
  
  let textView: UITextView = {
    let textView = UITextView()
    textView.font = .systemFont(ofSize: 20, weight: .regular)
    textView.isScrollEnabled = false
    textView.textColor = .white
    textView.backgroundColor = .clear
    textView.textAlignment = .center
    return textView
  }()
  
  let confirmBtn: UIButton = {
    let button = UIButton(
      text: "Okay",
      font: .systemFont(ofSize: 22, weight: .regular),
      textColor: .primaryRed,
      backgroundColor: .white,
      cornerRadius: 6
    )
    return button
  }()
  
  let denyBtn: UIButton = {
    let button = UIButton(
      text: "No Thanks",
      font: .systemFont(ofSize: 22, weight: .regular),
      textColor: .white,
      backgroundColor: .primaryRed,
      cornerRadius: 6
    )
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.borderWidth = 2
//    button.layer.masksToBounds = true
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .primaryRed
    setupSubviews()
  }
  
  init(titleText: String, detailText: String) {
    super.init(nibName: nil, bundle: nil)
    self.titleLabel.text = titleText
    self.textView.text = detailText
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension OnboardingBaseViewController {
  func setupSubviews() {
    view.addSubview(image)
    view.addSubview(titleLabel)
    view.addSubview(textView)
    view.addSubview(confirmBtn)
    view.addSubview(denyBtn)
    
    titleLabel.anchor(
      top: view.centerYAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: textView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 16, bottom: 10, right: 16)
    )
    
    image.anchor(
      top: nil, leading: nil,
      bottom: titleLabel.topAnchor, trailing: nil,
      padding: .init(top: 0, left: 0, bottom: 53, right: 0)
    )
    image.centerXInSuperview()
    
    textView.anchor(
      top: titleLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 10, left: 16, bottom: 0, right: 16)
    )
    textView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    
    denyBtn.anchor(
      top: confirmBtn.bottomAnchor, leading: nil,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil,
      padding: .init(top: 10, left: 0, bottom: 95, right: 0)
    )
    denyBtn.constrainWidth(constant: 151)
    denyBtn.constrainHeight(constant: 44)
    
    confirmBtn.anchor(
      top: nil, leading: nil,
      bottom: denyBtn.topAnchor, trailing: nil,
      padding: .init(top: 0, left: 0, bottom: 10, right: 0)
    )
    confirmBtn.constrainWidth(widthAnchor: denyBtn.widthAnchor)
    confirmBtn.constrainHeight(heightAnchor: denyBtn.heightAnchor)
  }
}
