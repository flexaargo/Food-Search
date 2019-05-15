//
//  RestaurantViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class RestaurantViewController: UIViewController {
  
  private var restaurant: YRestaurantDetail?
  private var reviews: YRestaurantReviews?
  private var restaurantRequest: AnyObject?
  private var reviewReqiest: AnyObject?
  
  lazy var scrollView = DetailScrollView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  init(restaurantId: String, name: String) {
    super.init(nibName: nil, bundle: nil)
    title = name
    scrollView.mapView.mapView.delegate = self
    scrollView.reviewsView.reviewsCollectionView.delegate = self
    scrollView.reviewsView.reviewsCollectionView.dataSource = self
    fetchRestaurant(withId: restaurantId)
    fetchRestaurantReviews(withId: restaurantId)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension RestaurantViewController {
  func setup() {
    view.backgroundColor = .white
    extendedLayoutIncludesOpaqueBars = true
    navigationItem.largeTitleDisplayMode = .never
    
    // MARK: - Setup subviews
    view.addSubview(scrollView)
    
    scrollView.anchor(
      top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor
    )
  }
  
  func fetchRestaurant(withId id: String) {
    var restaurantDetailResource = RestaurantDetailResource()
    restaurantDetailResource.id = id
    let restaurantDetailsRequest = YelpApiRequest(resource: restaurantDetailResource)
    restaurantRequest = restaurantDetailsRequest
    restaurantDetailsRequest.load { [weak self] (restaurant) in
      guard let restaurant = restaurant else {
        print("failed")
        return
      }
      self?.restaurant = restaurant
      print(restaurant.name)
      DispatchQueue.main.async {
        self?.assignValues()
      }
    }
  }
  
  func fetchRestaurantReviews(withId id: String) {
    var reviewsResource = ReviewsResource()
    reviewsResource.id = id
    let reviewsRequest = YelpApiRequest(resource: reviewsResource)
    reviewReqiest = reviewsRequest
    reviewsRequest.load { [weak self] (reviews) in
      guard let reviews = reviews else {
        print("failed")
        return
      }
      self?.reviews = reviews
      DispatchQueue.main.async {
        self?.scrollView.reviewsView.reviewsCollectionView.reloadData()
      }
    }
  }
  
  func assignValues() {
    scrollView.headerView.detailHeader = DetailHeader(
      name: restaurant!.name,
      reviewCount: restaurant!.reviewCount,
      rating: restaurant!.rating,
      price: restaurant!.price,
      categories: restaurant!.categories,
      hours: restaurant!.hours
    )
    
    scrollView.mapView.location = restaurant!.coordinates
    
    scrollView.imageView.sd_setImage(with: URL(string: restaurant!.imageURL)!, completed: nil)
  }
}

extension RestaurantViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
    for view in views {
      view.isEnabled = false
    }
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if !(annotation is MKPointAnnotation) {
      return nil
    }
    
    let annotationIdentifier = "pin"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
    
    if annotationView == nil {
      annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
      annotationView!.canShowCallout = true
    } else {
      annotationView!.annotation = annotation
    }
    
    let pinImage = UIImage(named: "pin.png")
    annotationView!.image = pinImage
    annotationView!.centerOffset = .init(x: 0, y: -annotationView!.frame.height/2)
    
    return annotationView
  }
}

extension RestaurantViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let reviews = reviews else {
      return 0
    }
    return reviews.reviews.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCell.reuseIdentifier, for: indexPath) as! ReviewCell
    
    guard let reviews = reviews else {
      return cell
    }
    
    let review = reviews.reviews[indexPath.row]
    
    cell.review = review
    cell.delegate = self
    cell.profileImage.sd_setImage(with: URL(string: review.user.imageURL)!, completed: nil)
    
    return cell
  }
}

extension RestaurantViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: 222, height: 210)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 12
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .init(top: 8, left: 16, bottom: 8, right: 16)
  }
}

extension RestaurantViewController: ReviewCellDelegate {
  func reviewCell(_ reviewCell: ReviewCell, linkTappedWithUrl url: URL) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}
