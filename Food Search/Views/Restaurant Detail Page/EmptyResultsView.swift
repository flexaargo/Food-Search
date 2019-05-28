//
//  EmptyResultsView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/27/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class EmptyResultsView: UIView {
  let label = UILabel(
    font: .systemFont(ofSize: 20, weight: .regular),
    textColor: .textLight
  )
  
  init(price: String, category: String) {
    super.init(frame: .zero)
    backgroundColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.text = """
    Oops. Try again.
    
    It looks like there are no \(price) \(category) restaurants open near this location.
    """
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private Methods
private extension EmptyResultsView {
  func setupSubviews() {
    addSubview(label)
    
    label.centerInSuperview()
    label.anchor(
      top: nil, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 16, bottom: 0, right: 16)
    )
  }
}
