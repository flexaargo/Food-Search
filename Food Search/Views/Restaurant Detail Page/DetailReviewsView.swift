//
//  DetailReviewsView.swift
//  Food Search
//
//  Created by Alex Fargo on 5/14/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DetailReviewsView: UIView {
  let titleLabel: UILabel = {
    let label = UILabel(
      text: "Reviews",
      font: .systemFont(ofSize: 24, weight: .bold),
      textColor: .black
    )
    return label
  }()
  
  let reviewsCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.backgroundColor = .clear
    collection.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.reuseIdentifier)
    collection.delaysContentTouches = false
    return collection
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension DetailReviewsView {
  func setupSubviews() {
    addSubview(titleLabel)
    addSubview(reviewsCollectionView)
    
    titleLabel.anchor(
      top: topAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: reviewsCollectionView.topAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 12, left: 16, bottom: 0, right: 16)
    )
    
    reviewsCollectionView.anchor(
      top: titleLabel.bottomAnchor, leading: safeAreaLayoutGuide.leadingAnchor,
      bottom: bottomAnchor, trailing: safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 8, right: 0)
    )
    reviewsCollectionView.constrainHeight(constant: 226)
  }
}
