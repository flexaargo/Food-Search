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
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .white
    alpha = 0
    label.textAlignment = .center
    label.numberOfLines = 0
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

// MARK: - Public Methods
extension EmptyResultsView {
  func setText(price: String, category: String) {
    label.text = "Oops. Try again.\n\nIt looks like there are no restaurants with the inputed categories currently open near this location."
  }
}
