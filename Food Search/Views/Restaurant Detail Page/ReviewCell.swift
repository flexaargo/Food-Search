//
//  ReviewCell.swift
//  Food Search
//
//  Created by Alex Fargo on 5/14/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
  let profileImage: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .lightGray
    image.layer.cornerRadius = 19
    image.clipsToBounds = true
    image.layer.borderWidth = 1
    image.layer.borderColor = UIColor.primaryRed.cgColor
    return image
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel(
      text: "Thu T.",
      font: .systemFont(ofSize: 20, weight: .bold),
      textColor: .black
    )
    return label
  }()
  
  let dateLabel: UILabel = {
    let label = UILabel(
      text: "April 4, 2019",
      font: .systemFont(ofSize: 12, weight: .regular),
      textColor: .textLight
    )
    return label
  }()
  
  let starsImage: UIImageView = {
    let image = UIImageView(image: UIImage(named: "small_5.png"))
    return image
  }()
  
  let bodyText: UITextView = {
    let textView = UITextView()
    textView.font = .systemFont(ofSize: 16, weight: .regular)
    textView.text = """
    Wonderfully delicious! Pricing is very reasonable - $21.99 per person for weekday dinners and weekends. We ordered: brisket, premium steak, beef tongue,...
    """
    textView.isScrollEnabled = false
    textView.backgroundColor = .clear
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = 0
    return textView
  }()
  
  let readMore: UILabel = {
    let label = UILabel(
      text: "Read more on Yelp",
      font: .systemFont(ofSize: 16, weight: .regular),
      textColor: .linkBlue
    )
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .backgroundLight
    layer.cornerRadius = 8
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension ReviewCell {
  func setupSubviews() {
    let infoStack = stackH(
      profileImage,
      stackV(
        nameLabel,
        dateLabel,
        spacing: 0,
        distribution: .fill
      ),
      spacing: 8,
      distribution: .fill
    )
    
    addSubview(infoStack)
    addSubview(starsImage)
    addSubview(bodyText)
    addSubview(readMore)
    
    profileImage.constrainWidthToHeight()
    
    infoStack.anchor(
      top: topAnchor, leading: leadingAnchor,
      bottom: starsImage.topAnchor, trailing: trailingAnchor,
      padding: .init(top: 6, left: 6, bottom: 6, right: 6)
    )
    infoStack.constrainHeight(constant: 38)
    
    starsImage.anchor(
      top: infoStack.bottomAnchor, leading: leadingAnchor,
      bottom: bodyText.topAnchor, trailing: nil,
      padding: .init(top: 6, left: 6, bottom: 6, right: 0)
    )
    
    bodyText.anchor(
      top: starsImage.bottomAnchor, leading: leadingAnchor,
      bottom: readMore.topAnchor, trailing: trailingAnchor,
      padding: .init(top: 6, left: 6, bottom: 2, right: 6)
    )
    
    readMore.anchor(
      top: bodyText.bottomAnchor, leading: leadingAnchor,
      bottom: nil, trailing: nil,
      padding: .init(top: 2, left: 6, bottom: 0, right: 0)
    )
    
    readMore.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -6).isActive = true
    
  }
}

extension ReviewCell: ReuseIdentifying {}
