//
//  DetailHeaderView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/13/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DetailHeaderView: UIView {
  
  var detailHeader: DetailHeader! {
    didSet {
      nameLabel.text = detailHeader.name
      reviewsLabel.text = detailHeader.reviewCount.formattedReviewCount
      
      category1.label.text = detailHeader.categories[0].title
      category2.isHidden = true
      category3.isHidden = true
      if detailHeader.categories.count > 1 {
        category2.isHidden = false
        category2.label.text = detailHeader.categories[1].title
      }
      
      if detailHeader.categories.count > 2 {
        category3.isHidden = false
        category3.label.text = detailHeader.categories[2].title
        layoutIfNeeded()
        // The category label is too large for the stackview
//        print(categoriesStack.frame.maxX)
//        print(UIScreen.main.bounds.maxX - 16)
        if categoriesStack.frame.maxX >= UIScreen.main.bounds.maxX - 16 {
          categoriesBottomAnchor.isActive = false
          openStatusTopAnchor.isActive = false
          
          categoriesStack.removeArrangedSubview(category3)
          addSubview(category3)
          
          category3.anchor(
            top: categoriesStack.bottomAnchor, leading: categoriesStack.leadingAnchor,
            bottom: openStatusLabel.topAnchor, trailing: nil,
            padding: .init(top: 4, left: 0, bottom: 10, right: 0)
          )
          
          categoriesStack.bottomAnchor.constraint(equalTo: category3.topAnchor, constant: -4)
          
          openStatusLabel.topAnchor.constraint(equalTo: category3.bottomAnchor, constant: 10)
          layoutIfNeeded()
        }
      }
      
      let priceText = NSMutableAttributedString()
      if let price = detailHeader.price {
        if price.count == 1 {
          priceText.append(NSMutableAttributedString(string: "$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
          priceText.append(NSMutableAttributedString(string: "$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textLight]))
        } else if price.count == 2 {
          priceText.append(NSMutableAttributedString(string: "$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
          priceText.append(NSMutableAttributedString(string: "$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textLight]))
        } else if price.count == 3 {
          priceText.append(NSMutableAttributedString(string: "$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
          priceText.append(NSMutableAttributedString(string: "$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textLight]))
        } else {
          priceText.append(NSMutableAttributedString(string: "$$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
        }
      } else {
        priceText.append(NSMutableAttributedString(string: "$$$$", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textLight]))
      }
      priceLabel.attributedText = priceText
      
      var starsImageName = "small_"
      switch detailHeader.rating {
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
      
      let openStatusText = NSMutableAttributedString()
      let today = getCurrentYelpDay()
      var todaysHours: [Hours] = []
      
      for hours in detailHeader.hours {
        if hours.day == today {
          todaysHours.append(hours)
        }
      }
      
      let currentTime = Calendar.current.component(.hour, from: Date()) * 100 + Calendar.current.component(.minute, from: Date())
      if !detailHeader.isOpenNow {
//        print("Closed")
        openStatusText.append(NSAttributedString(string: "Closed ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.primaryRed]))
        for hours in todaysHours {
          let timeFormatter = DateFormatter()
          timeFormatter.dateFormat = "HHmm"
          let openingTimeDate = timeFormatter.date(from: hours.start)
          let closingTimeDate = timeFormatter.date(from: hours.end)
          timeFormatter.dateFormat = "h:mm a"
          let openingTime = timeFormatter.string(from: openingTimeDate!)
          let closingTime = timeFormatter.string(from: closingTimeDate!)
          print("\(openingTime) - \(closingTime)")
          openStatusText.append(NSAttributedString(string: "\(openingTime)-\(closingTime)  "))
        }
      } else {
//        print("Open")
        openStatusText.append(NSAttributedString(string: "Open ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.textGreen]))
        for hours in todaysHours {
          var end = hours.end == "0000" ? 2400 : Int(hours.end)!
          if hours.isOvernight {
            end = 2400 + Int(hours.end)!
          }
          if currentTime < end && currentTime >= Int(hours.start)!{
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HHmm"
            let closingTimeDate = timeFormatter.date(from: hours.end)
            timeFormatter.dateFormat = "h:mm a"
            openStatusText.append(NSAttributedString(string: "until \(timeFormatter.string(from: closingTimeDate!))"))
            break
          }
        }
      }
      openStatusLabel.attributedText = openStatusText
    }
  }
  
  let nameLabel: UILabel = {
    let label = UILabel(
      text: "Gen Korean BBQ House",
      font: .systemFont(ofSize: 24, weight: .bold),
      textColor: .black
    )
    label.numberOfLines = 0
    return label
  }()
  
  let starsImage: UIImageView = {
    let image = UIImageView(image: UIImage(named: "regular_5.png"))
    return image
  }()
  
  let reviewsLabel: UILabel = {
    let label = UILabel(
      text: "1,673 Reviews",
      font: .systemFont(ofSize: 14, weight: .regular),
      textColor: .black
    )
    return label
  }()
  
  let priceLabel: UILabel = {
    let label = UILabel(
      text: "$$$$",
      font: .systemFont(ofSize: 14, weight: .light),
      textColor: .black
    )
    return label
  }()
  
  let separator: UIView = {
    let view = UIView()
    view.backgroundColor = .separator
    view.layer.cornerRadius = 3
    return view
  }()
  
  let category1 = CategoryView()
  let category2 = CategoryView()
  let category3 = CategoryView()
  
  lazy var categoriesStack = stackH(
    category1,
    category2,
    category3,
    spacing: 4,
    distribution: .fill
  )
  
  var categoriesBottomAnchor: NSLayoutConstraint!
  
  let openStatusLabel: UILabel = {
    let label = UILabel(
      text: "Open until 10:30 PM",
      font: .systemFont(ofSize: 12, weight: .regular),
      textColor: .textLight
    )
    return label
  }()
  
  var openStatusTopAnchor: NSLayoutConstraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    category1.label.text = "Korean"
    category2.label.text = "Barbeque"
    category3.label.text = "Asian Fusion"
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension DetailHeaderView {
  func setupSubviews() {
    let reviewsStack = stackH(
      starsImage,
      reviewsLabel,
      spacing: 6,
      distribution: .fill
    )
    
    
    
    addSubview(nameLabel)
    addSubview(reviewsStack)
    addSubview(priceLabel)
    addSubview(separator)
    addSubview(categoriesStack)
    addSubview(openStatusLabel)
    
    nameLabel.anchor(
      top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: reviewsStack.topAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 12, left: 16, bottom: 8, right: 16)
    )
    
    reviewsStack.anchor(
      top: nameLabel.bottomAnchor, leading: nameLabel.leadingAnchor,
      bottom: categoriesStack.topAnchor, trailing: nil,
      padding: .init(top: 8, left: 0, bottom: 12, right: 0)
    )
    reviewsStack.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    starsImage.constrainHeight(constant: 18)
    starsImage.constrainWidth(constant: 102)
    
    priceLabel.anchor(
      top: categoriesStack.topAnchor, leading: reviewsStack.leadingAnchor,
      bottom: categoriesStack.bottomAnchor, trailing: separator.leadingAnchor,
      padding: .init(top: 0, left: 0, bottom: 0, right: 4)
    )
    
    separator.anchor(
      top: nil, leading: priceLabel.trailingAnchor,
      bottom: nil, trailing: categoriesStack.leadingAnchor,
      padding: .init(top: 0, left: 4, bottom: 0, right: 4)
    )
    separator.centerYAnchor.constraint(equalTo: categoriesStack.centerYAnchor).isActive = true
    separator.constrainWidth(constant: 6)
    separator.constrainHeightToWidth()
    
    categoriesStack.anchor(
      top: reviewsStack.bottomAnchor, leading: separator.trailingAnchor,
      bottom: nil, trailing: nil,
      padding: .init(top: 12, left: 4, bottom: 0, right: 0)
    )
    categoriesStack.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
    categoriesBottomAnchor = categoriesStack.bottomAnchor.constraint(equalTo: openStatusLabel.topAnchor, constant: -10)
    categoriesBottomAnchor.isActive = true
    categoriesBottomAnchor.identifier = "$Categories Buttom Anchor$"
    
    openStatusLabel.anchor(
      top: nil, leading: nameLabel.leadingAnchor,
      bottom: bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 12, right: 16)
    )
    openStatusTopAnchor = openStatusLabel.topAnchor.constraint(equalTo: categoriesStack.bottomAnchor, constant: 10)
    openStatusTopAnchor.isActive = true
    openStatusTopAnchor.identifier = "$Open Status Top Anchor$"
  }
}
