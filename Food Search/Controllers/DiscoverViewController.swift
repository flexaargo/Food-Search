//
//  DiscoverViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
  
  private var restaurants: [YRestaurantSimple] = []
  private var request: AnyObject?
  
  lazy var searchView: DiscoverSearchView = {
    return DiscoverSearchView(frame: .zero)
  }()
  
  lazy var tableView: DiscoverTableView = {
    return DiscoverTableView(frame: .zero, style: .plain)
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
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
//    tableView.rowHeight = UITableView.automaticDimension
    
    view.addSubview(searchView)
    view.addSubview(tableView)
    
    searchView.anchor(
      top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: tableView.topAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 0, right: 0)
    )
    
    tableView.anchor(
      top: searchView.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor,
      bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor,
      padding: .init(top: 0, left: 0, bottom: 0, right: 0)
    )
  }
  
  func fetchHotAndNew() {
    var searchResultsResource = SearchResultsResource()
    searchResultsResource.params = [
      "location=Chino%20Hills)",
      "attributes=hot_and_new",
      "categories=restaurants"
//      "open_now=true"
    ]
    let searchResultsRequest = YelpApiRequest(resource: searchResultsResource)
    request = searchResultsRequest
    searchResultsRequest.load { [weak self] (searchResult) in
      guard let restaurants = searchResult?.restaurants else {
        return
      }
      self?.restaurants = restaurants
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
  }
}

extension DiscoverViewController: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 98
//  }
}

extension DiscoverViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return restaurants.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCell.reuseIdentifier, for: indexPath) as! RestaurantCell
    
    cell.restaurant = restaurants[indexPath.row]
    
    return cell
  }
  
  
}
