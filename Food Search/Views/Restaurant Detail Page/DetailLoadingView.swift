//
//  DetailLoadingView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/15/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DetailLoadingView: UIView {
  var color: UIColor
  
  init(color: UIColor) {
    self.color = color
    super.init(frame: .zero)
    backgroundColor = .clear
    
    let v1 = ColorView(color)
    let v2 = ColorView(color)
    let v3 = ColorView(color)
    let v4 = ColorView(color)
    let v5 = ColorView(color)
    let v6 = ColorView(color)
    let v7 = ColorView(color)
    addSubview(v1)
    addSubview(v2)
    addSubview(v3)
    addSubview(v4)
    addSubview(v5)
    addSubview(v6)
    addSubview(v7)
    v1.anchor(
      top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor,
      bottom: v2.topAnchor, trailing: trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 12, right: 0)
    )
    v1.constrainHeight(constant: 225)
    
    v2.anchor(
      top: v1.bottomAnchor, leading: leadingAnchor,
      bottom: v3.topAnchor, trailing: nil,
      padding: .init(top: 12, left: 16, bottom: 8, right: 0)
    )
    v2.constrainHeight(constant: 29)
    v2.constrainWidth(constant: 220)
    
    v3.anchor(
      top: v2.bottomAnchor, leading: leadingAnchor,
      bottom: v4.topAnchor, trailing: nil,
      padding: .init(top: 8, left: 16, bottom: 12, right: 0)
    )
    v3.constrainHeight(constant: 18)
    v3.constrainWidth(constant: 170)
    
    v4.anchor(
      top: v3.bottomAnchor, leading: leadingAnchor,
      bottom: v5.topAnchor, trailing: nil,
      padding: .init(top: 12, left: 16, bottom: 10, right: 0)
    )
    v4.constrainHeight(constant: 18)
    v4.constrainWidth(constant: 240)
    
    v5.anchor(
      top: v4.bottomAnchor, leading: leadingAnchor,
      bottom: v6.topAnchor, trailing: nil,
      padding: .init(top: 10, left: 16, bottom: 12, right: 0)
    )
    v5.constrainHeight(constant: 14)
    v5.constrainWidth(constant: 76)
    
    v6.anchor(
      top: v5.bottomAnchor, leading: leadingAnchor,
      bottom: v7.topAnchor, trailing: trailingAnchor,
      padding: .init(top: 12, left: 0, bottom: 12, right: 0)
    )
    v6.constrainHeight(constant: 200)
    
    v7.anchor(
      top: v6.bottomAnchor, leading: leadingAnchor,
      bottom: nil, trailing: nil,
      padding: .init(top: 12, left: 16, bottom: 0, right: 0)
    )
    v7.constrainHeight(constant: 29)
    v7.constrainWidth(constant: 120)
    
    layoutIfNeeded()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
