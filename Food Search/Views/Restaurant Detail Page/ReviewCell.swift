//
//  ReviewCell.swift
//  Food Search
//
//  Created by Alex Fargo on 5/14/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

protocol ReviewCellDelegate: class {
  func reviewCell(_ reviewCell: ReviewCell, linkTappedWithUrl url: URL)
}

class ReviewCell: UICollectionViewCell {
  var review: YRestaurantReview! {
    didSet {
      nameLabel.text = review.user.name
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      let date = dateFormatter.date(from: review.timeCreated)
      dateFormatter.dateFormat = "MMM dd, yyyy"
      dateLabel.text = dateFormatter.string(from: date!)
      bodyText.text = review.text.replacingOccurrences(of: "\n\n", with: "\n")
      var starsImageName = "small_"
      switch review!.rating {
      case 0:
        starsImageName += "0"
      case 1:
        starsImageName += "1"
      case 1.5:
        starsImageName += "1_half"
      case 2:
        starsImageName += "2"
      case 2.5:
        starsImageName += "2_half"
      case 3:
        starsImageName += "3"
      case 3.5:
        starsImageName += "3_half"
      case 4:
        starsImageName += "4"
      case 4.5:
        starsImageName += "4_half"
      case 5:
        starsImageName += "5"
      default:
        starsImageName += "0"
      }
      starsImageName += ".png"
      starsImage.image = UIImage(named: starsImageName)
    }
  }
  
  weak var delegate: ReviewCellDelegate?
  
  let profileImage: UIImageView = {
    let image = UIImageView()
    image.backgroundColor = .lightGray
    image.layer.cornerRadius = 19
    image.clipsToBounds = true
    image.layer.borderWidth = 1
    image.layer.borderColor = UIColor.primaryRed.cgColor
    image.contentMode = .scaleAspectFill
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
  
  let bodyText: UILabel = {
    let label = UILabel(
      text: "Wonderfully delicious! Pricing is very reasonable - $21.99 per person for weekday dinners and weekends. We ordered: brisket, premium steak, beef tongue,...",
      font: .systemFont(ofSize: 16, weight: .regular),
      textColor: .black
    )
    label.lineBreakMode = NSLineBreakMode.byTruncatingTail
    label.numberOfLines = 0
    return label
  }()
  
  let readMore: UIButton = {
    let button = UIButton(
      text: "View on Yelp",
      font: .systemFont(ofSize: 16, weight: .regular),
      textColor: .linkBlue,
      backgroundColor: .clear
    )
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .backgroundLight
    layer.cornerRadius = 8
    readMore.addTarget(self, action: #selector(didTapViewOnYelp), for: .touchUpInside)
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
    bodyText.heightAnchor.constraint(lessThanOrEqualToConstant: 115).isActive = true
    
    readMore.anchor(
      top: bodyText.bottomAnchor, leading: leadingAnchor,
      bottom: nil, trailing: nil,
      padding: .init(top: 2, left: 6, bottom: 0, right: 0)
    )
    
    readMore.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -6).isActive = true
    
  }
  
  @objc func didTapViewOnYelp() {
    delegate?.reviewCell(self, linkTappedWithUrl: URL(string: review.url)!)
  }
}

extension ReviewCell: ReuseIdentifying {}
