//
//  Helpers.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

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
