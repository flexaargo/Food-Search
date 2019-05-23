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
  
  var initialVC: OnboardingBaseViewController?
  var pageNumber: Int!
  
  let imageView: UIImageView = {
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
  
  init(titleText: String, detailText: String, image: UIImage? = nil, pageNumber: Int? = nil) {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = UIModalPresentationStyle.fullScreen
    transitioningDelegate = self
//    modalTransitionStyle = UIModalTransitionStyle.coverVertical
    self.titleLabel.text = titleText
    self.textView.text = detailText
    if let image = image {
      self.imageView.image = image
    }
    if let pageNumber = pageNumber {
      self.pageNumber = pageNumber
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension OnboardingBaseViewController {
  func setupSubviews() {
    view.addSubview(imageView)
    view.addSubview(titleLabel)
    view.addSubview(textView)
    view.addSubview(confirmBtn)
    view.addSubview(denyBtn)
    
    titleLabel.anchor(
      top: view.centerYAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: textView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 16, bottom: 10, right: 16)
    )
    
    imageView.anchor(
      top: nil, leading: nil,
      bottom: titleLabel.topAnchor, trailing: nil,
      padding: .init(top: 0, left: 0, bottom: 53, right: 0)
    )
    imageView.centerXInSuperview()
    
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
    denyBtn.centerXInSuperview()
    
    confirmBtn.anchor(
      top: nil, leading: nil,
      bottom: denyBtn.topAnchor, trailing: nil,
      padding: .init(top: 0, left: 0, bottom: 10, right: 0)
    )
    confirmBtn.constrainWidth(constant: 151)
    confirmBtn.constrainHeight(constant: 44)
    confirmBtn.centerXInSuperview()
  }
}

extension OnboardingBaseViewController {
  func dismissOnboardingScreens() {
    var prevVC = self.presentingViewController
    let current = self
    while(prevVC?.presentingViewController != nil) {
      prevVC = prevVC?.presentingViewController
    }
    current.dismiss(animated: true) {
      prevVC?.dismiss(animated: false, completion: nil)
    }
  }
  
  func goToNextOnboardingScreen(next: OnboardingBaseViewController, prev: OnboardingBaseViewController) {
    next.initialVC = initialVC
    next.pageNumber = pageNumber + 1
    present(next, animated: true) {
      prev.view.isHidden = true
    }
  }
}

extension OnboardingBaseViewController: UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ModalPushAnimator()
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ModalPopAnimator()
  }
}
