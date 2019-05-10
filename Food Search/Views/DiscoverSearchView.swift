//
//  DiscoverSearchView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DiscoverSearchView: UIView {
  public let locationField: UITextField = {
    let textField = CustomTextField(
      font: .systemFont(ofSize: 18, weight: .regular),
      placeholder: "Location",
      backgroundColor: .backgroundLight,
      cornerRadius: 10,
      padding: .init(top: 6, left: 10, bottom: 6, right: 10)
    )
    return textField
  }()
  
  public let cuisineField: UITextField = {
    let textField = CustomTextField(
      font: .systemFont(ofSize: 18, weight: .regular),
      placeholder: "Cuisine",
      backgroundColor: .backgroundLight,
      cornerRadius: 10,
      padding: .init(top: 6, left: 10, bottom: 6, right: 10)
    )
    return textField
  }()
  
  public let priceField: UITextField = {
    let textField = CustomTextField(
      font: .systemFont(ofSize: 18, weight: .regular),
      placeholder: "$$$$",
      backgroundColor: .backgroundLight,
      cornerRadius: 10,
      padding: .init(top: 6, left: 10, bottom: 6, right: 10)
    )
    return textField
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .orange
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Private methods
private extension DiscoverSearchView {
  func setupSubviews() {
    let fieldStackView = stackH(cuisineField, priceField, spacing: 7)
    
    addSubview(locationField)
    addSubview(fieldStackView)
    
    locationField.anchor(
      top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: fieldStackView.topAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 22, left: 16, bottom: 12, right: 16)
    )
    
    fieldStackView.anchor(
      top: locationField.bottomAnchor, leading: locationField.leadingAnchor,
      bottom: bottomAnchor, trailing: locationField.trailingAnchor,
      padding: .init(top: 12, left: 0, bottom: 12, right: 0)
    )
  }
}
