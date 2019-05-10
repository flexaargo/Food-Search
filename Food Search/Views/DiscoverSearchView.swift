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
      font: UIFont.systemFont(ofSize: 18, weight: .regular),
      placeholder: "Location",
      backgroundColor: .backgroundLight,
      cornerRadius: 10,
      padding: .init(top: 6, left: 10, bottom: 6, right: 10)
    )
    return textField
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    backgroundColor = .orange
    addSubview(locationField)
    locationField.anchor(
      top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 22, left: 16, bottom: 0, right: 16)
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
