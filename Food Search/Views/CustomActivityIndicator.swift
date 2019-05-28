//
//  ActivityIndicatorView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/27/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIView {
  private let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
  
  private let aiv: UIActivityIndicatorView = {
    let aiv = UIActivityIndicatorView(style: .whiteLarge)
    aiv.hidesWhenStopped = true
    aiv.startAnimating()
    aiv.color = .black
    return aiv
  }()
  
  init() {
    super.init(frame: .zero)
//    backgroundColor = .activtyIndicatorBackground
    layer.cornerRadius = 16
    clipsToBounds = true
    hide()
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Methods
private extension CustomActivityIndicator {
  func setupSubviews() {
    addSubview(effectView)
    
    effectView.fillSuperview()
    
    effectView.contentView.addSubview(aiv)
    
    aiv.centerInSuperview()
  }
}

// MARK: - Public Methods
extension CustomActivityIndicator {
  func show() {
    aiv.startAnimating()
    UIView.animate(withDuration: 0.2) {
      self.alpha = 1
    }
  }
  
  func hide() {
    UIView.animate(withDuration: 0.2, animations: {
      self.alpha = 0
    }, completion: { _ in
      self.aiv.stopAnimating()
    })
  }
}
