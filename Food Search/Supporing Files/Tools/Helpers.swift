//
//  Helpers.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

private func stack(views: [UIView], spacing: CGFloat = 0,
                   distribution: UIStackView.Distribution) -> UIStackView {
  let stackView = UIStackView()
  for view in views {
    stackView.addArrangedSubview(view)
  }
  stackView.spacing = spacing
  stackView.distribution = distribution
  return stackView
}

public func stack(_ views: UIView..., spacing: CGFloat = 0,
                  distribution: UIStackView.Distribution = .fillEqually) -> UIStackView {
  return stack(views: views, spacing: spacing, distribution: distribution)
}

public func stackH(_ views: UIView..., spacing: CGFloat = 0,
                   distribution: UIStackView.Distribution = .fillEqually) -> UIStackView {
  let stackView = stack(views: views, spacing: spacing, distribution: distribution)
  stackView.axis = .horizontal
  return stackView
}

class CustomTextField: UITextField {
  var padding: UIEdgeInsets!
  
  public convenience init(font: UIFont, placeholder: String, backgroundColor: UIColor, cornerRadius: CGFloat = 0, padding: UIEdgeInsets = .zero) {
    self.init()
    self.font = font
    self.placeholder = placeholder
    self.backgroundColor = backgroundColor
    layer.cornerRadius = cornerRadius
    self.padding = padding
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}
