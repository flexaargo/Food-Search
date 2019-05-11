//
//  DiscoverViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
  
  private var request: AnyObject?
  
  lazy var searchView: DiscoverSearchView = {
    return DiscoverSearchView(frame: .zero)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    fetchHotAndNew()
  }
}

private extension DiscoverViewController {
  func setup() {
    title = "Discover"
    view.backgroundColor = .white
    view.addSubview(searchView)
    searchView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 0, right: 0)
    )
  }
  
  func fetchHotAndNew() {
    var searchResultsResource = SearchResultsResource()
    searchResultsResource.params = [
      "location=Chino%20Hills)",
      "attributes=hot_and_new",
      "open_now=true"
    ]
    let searchResultsRequest = YelpApiRequest(resource: searchResultsResource)
    request = searchResultsRequest
    searchResultsRequest.load { [weak self] (searchResult) in
      guard let restaurants = searchResult?.restaurants else {
        return
      }
      print(restaurants[0].name)
    }
  }
}
