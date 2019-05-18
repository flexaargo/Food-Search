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

public func stackV(_ views: UIView..., spacing: CGFloat = 0,
                   distribution: UIStackView.Distribution = .fillEqually) -> UIStackView {
  let stackView = stack(views: views, spacing: spacing, distribution: distribution)
  stackView.axis = .vertical
  return stackView
}

class PaddedTextField: UITextField {
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

extension UIButton {
  public convenience init(text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil,
                          backgroundColor: UIColor? = nil, cornerRadius: CGFloat = 0,
                          padding: UIEdgeInsets = .zero) {
    self.init(type: .system)
    setTitle(text, for: .normal)
    titleLabel?.font = font
    setTitleColor(textColor, for: .normal)
    self.backgroundColor = backgroundColor
    layer.cornerRadius = cornerRadius
    titleEdgeInsets = padding
  }
  
  public convenience init(image: UIImage, backgroundColor: UIColor? = nil,
                          cornerRadius: CGFloat = 0, padding: UIEdgeInsets = .zero) {
    self.init(backgroundColor: backgroundColor, cornerRadius: cornerRadius)
    setImage(image, for: .normal)
    tintColor = .white
    imageEdgeInsets = padding
  }
}

extension UILabel {
  public convenience init(text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil) {
    self.init()
    self.text = text
    self.font = font
    self.textColor = textColor
  }
}

public func convertToMiles(meters: Double) -> Double {
  return meters * 0.00062137
}

extension Double {
  var formattedMiles: String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 1
    formatter.minimumFractionDigits = 1
    formatter.minimumIntegerDigits = 1
    return formatter.string(from: NSNumber(value: self))! + " mi"
  }
}

extension Int {
  var formattedReviewCount: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: self))! + " Reviews"
  }
}

// Calling dismissKeyboardOnTap in ViewDidLoad of a ViewController will allow the user to tap outside of the keyboard to dismiss it
extension UIViewController {
  func dismissKeyboardOnTap() {
    let tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapToDismissKeyboard.cancelsTouchesInView = false
    view.addGestureRecognizer(tapToDismissKeyboard)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

class CategoryView: UIView {
  let label: UILabel = {
    let label = UILabel(
      font: .systemFont(ofSize: 12, weight: .light),
      textColor: .white
    )
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .primaryRed
    addSubview(label)
    layer.cornerRadius = 9
    label.anchor(
      top: topAnchor, leading: leadingAnchor,
      bottom: bottomAnchor, trailing: trailingAnchor,
      padding: .init(top: 2, left: 6, bottom: 2, right: 6)
    )
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ColorView: UIView {
  init(_ color: UIColor) {
    super.init(frame: .zero)
    backgroundColor = color
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

func getCurrentYelpDay() -> Int {
  let today = Calendar.current.component(.weekday, from: Date())
  switch today {
  case 1: return 6
  case 2: return 0
  case 3: return 1
  case 4: return 2
  case 5: return 3
  case 6: return 4
  case 7: return 5
  default: return -1
  }
}

extension Array {
  func randomItem() -> Element? {
    if isEmpty { return nil }
    let index = Int(arc4random_uniform(UInt32(self.count)))
    return self[index]
  }
}
