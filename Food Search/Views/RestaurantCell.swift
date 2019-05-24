//
//  RestaurantCell.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
  
  var restaurant: YRestaurantSimple? {
    didSet {
      nameLabel.text = restaurant!.name
      distanceLabel.text = convertToMiles(meters: restaurant!.distance).formattedMiles
      reviewsLabel.text = restaurant!.reviewCount.formattedReviewCount
      setAddressLabel(using: restaurant!.location)
      setStarsImage(using: restaurant!.rating)
    }
  }
  var restaurantDetail: YRestaurantDetail? {
    didSet {
      nameLabel.text = restaurantDetail!.name
      distanceLabel.text = ""
      reviewsLabel.text = restaurantDetail!.reviewCount.formattedReviewCount
      setAddressLabel(using: restaurantDetail!.location)
      setStarsImage(using: restaurantDetail!.rating)
    }
  }
  
  let nameLabel: UILabel = {
    let label = UILabel(
      font: .systemFont(ofSize: 19, weight: .bold),
      textColor: .black
    )
    label.numberOfLines = 0
    return label
  }()
  
  let distanceLabel: UILabel = {
    let label = UILabel(
      font: .systemFont(ofSize: 14, weight: .regular),
      textColor: .textLight
    )
    return label
  }()
  
  let starsImage: UIImageView = {
    let image = UIImageView(image: nil)
    return image
  }()
  
  let reviewsLabel: UILabel = {
    let label = UILabel(
      font: .systemFont(ofSize: 14, weight: .regular),
      textColor: .black
    )
    return label
  }()
  
  let addressLabel: UILabel = {
    let label = UILabel(
      font: .systemFont(ofSize: 14, weight: .regular),
      textColor: .textLight
    )
    return label
  }()
  
  
  let separator: UIView = {
    let view = UIView()
    view.backgroundColor = .separator
    return view
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}

private extension RestaurantCell {
  // MARK: - Setup
  func setupSubviews() {
//    let topStackView = stack(
//      nameLabel,
//      distanctLabel,
//      spacing: 8,
//      distribution: .fill
//    )
    
    let midStackView = stack(
      starsImage,
      reviewsLabel,
      spacing: 6,
      distribution: .fill
    )
    
//    addSubview(topStackView)
    addSubview(nameLabel)
    addSubview(distanceLabel)
    addSubview(midStackView)
    addSubview(addressLabel)
    addSubview(separator)
    
//    topStackView.anchor(
//      top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
//      bottom: midStackView.topAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
//      padding: .init(top: 10, left: 16, bottom: 6, right: 16)
//    )
    
    nameLabel.anchor(
      top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: midStackView.topAnchor, trailing: nil,
      padding: .init(top: 10, left: 16, bottom: 6, right: 0)
    )
    nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: distanceLabel.leadingAnchor, constant: -8).isActive = true
    nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    
    distanceLabel.anchor(
      top: nameLabel.topAnchor, leading: nil,
      bottom: nameLabel.bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 0, right: 16)
    )
    distanceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    
    midStackView.anchor(
      top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor,
      bottom: addressLabel.topAnchor, trailing: nil,
      padding: .init(top: 6, left: 0, bottom: 6, right: 0)
    )
    midStackView.trailingAnchor.constraint(lessThanOrEqualTo: distanceLabel.trailingAnchor).isActive = true
    starsImage.constrainHeight(constant: 14)
    
    addressLabel.anchor(
      top: midStackView.bottomAnchor, leading: nameLabel.leadingAnchor,
      bottom: separator.topAnchor, trailing: distanceLabel.trailingAnchor,
      padding: .init(top: 6, left: 0, bottom: 10, right: 0)
    )
    
    separator.constrainHeight(constant: 1)
    separator.anchor(
      top: addressLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 10, left: 16, bottom: 0, right: 16)
    )
  }
  
  // MARK: - Assign Values Methods
  func setAddressLabel(using location: Location) {
    var addressText = ""
    if let address1 = location.address1 {
      if address1 != "" {
        addressText += address1
      }
    }
    if let address2 = location.address2 {
      if address2 != "" {
        addressText += ", " + address2
      }
    }
    if addressText == "" {
      addressText += location.city
    } else {
      addressText += ", " + location.city
    }
    addressLabel.text = addressText
  }
  
  func setStarsImage(using rating: Double) {
    var starsImageName = "small_"
    switch rating {
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

extension RestaurantCell: ReuseIdentifying {}
