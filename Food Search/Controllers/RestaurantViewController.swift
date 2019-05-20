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
  
  private var restaurantId: String!
  private var restaurant: YRestaurantDetail?
  private var reviews: YRestaurantReviews?
  private var restaurantRequest: AnyObject?
  private var reviewReqiest: AnyObject?
  
  lazy var favoriteBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "star_unselected"), style: .plain, target: self, action: #selector(saveRestaurant))
  lazy var unfavoriteBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "star_selected"), style: .plain, target: self, action: #selector(unsaveRestaurant))
  
  lazy var scrollView = DetailScrollView()
  let loadingBackground = UIView()
  let shimmerView = DetailLoadingView(color: .loadingShimmer)
  let loadView = DetailLoadingView(color: .loadingColor)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupLoadingAnim()
  }
  
  init(restaurantId: String, name: String) {
    super.init(nibName: nil, bundle: nil)
    self.restaurantId = restaurantId
    title = name
    scrollView.mapView.mapView.delegate = self
    scrollView.reviewsView.reviewsCollectionView.delegate = self
    scrollView.reviewsView.reviewsCollectionView.dataSource = self
    let dispatchGroup = DispatchGroup()
    dispatchGroup.enter()
    fetchRestaurant(withId: restaurantId) {
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    fetchRestaurantReviews(withId: restaurantId) {
      dispatchGroup.leave()
    }
    dispatchGroup.notify(queue: .main) {
      print("Finished fetching all data")
      self.scrollView.isHidden = false
      self.shimmerView.isHidden = true
      self.loadView.isHidden = true
      self.loadingBackground.isHidden = true
    }
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
    
    // MARK: - Setup navigaton
    if Defaults.restaurantIsSaved(restaurantId) {
      navigationItem.rightBarButtonItems = [unfavoriteBtn]
    } else {
      navigationItem.rightBarButtonItems = [favoriteBtn]
    }
    
    // MARK: - Setup subviews
    view.addSubview(scrollView)
    scrollView.isHidden = true
    
    scrollView.anchor(
      top: view.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor
    )
  }
  
  func setupLoadingAnim() {
    loadingBackground.backgroundColor = .white
    view.addSubview(loadingBackground)
    loadingBackground.fillSuperview()
    view.addSubview(loadView)
    loadView.fillSuperview()
    view.addSubview(shimmerView)
    shimmerView.fillSuperview()
    
    view.layoutIfNeeded()
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
    gradientLayer.locations = [0, 0.5, 1]
    gradientLayer.frame = .init(x: 0, y: 0, width: shimmerView.frame.width*4, height: shimmerView.frame.height*0.5)
    
    let angle = -60 * CGFloat.pi / 180
    gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
    
    shimmerView.layer.mask = gradientLayer
    
    let animation = CABasicAnimation(keyPath: "transform.translation.x")
    animation.duration = 3
    animation.fromValue = -view.frame.width * 4
    animation.toValue = view.frame.width * 6
    animation.repeatCount = Float.infinity
    gradientLayer.add(animation, forKey: "")
  }
  
  func fetchRestaurant(withId id: String, completion: @escaping () -> Void) {
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
      completion()
    }
  }
  
  func fetchRestaurantReviews(withId id: String, completion: @escaping () -> Void) {
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
      completion()
    }
  }
  
  func assignValues() {
    scrollView.headerView.detailHeader = DetailHeader(
      name: restaurant!.name,
      reviewCount: restaurant!.reviewCount,
      rating: restaurant!.rating,
      price: restaurant!.price,
      categories: restaurant!.categories,
      hours: restaurant!.hours,
      isOpenNow: restaurant!.isOpenNow
    )
    
    scrollView.mapView.location = restaurant!.coordinates
    
    scrollView.imageView.sd_setImage(with: URL(string: restaurant!.imageURL)!, completed: nil)
  }
  
  @objc func saveRestaurant() {
    print("saved")
    navigationItem.setRightBarButtonItems([unfavoriteBtn], animated: false)
    Defaults.save(restaurantId: restaurantId)
  }
  
  @objc func unsaveRestaurant() {
    print("unsaved")
    navigationItem.setRightBarButtonItems([favoriteBtn], animated: false)
    Defaults.remove(restaurantId: restaurantId)
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
