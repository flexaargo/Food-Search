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
  
  lazy var categoryPicker: UIPickerView = {
    let picker = UIPickerView()
    picker.delegate = self
    picker.dataSource = self
    return picker
  }()
  
  lazy var pricePicker: UIPickerView = {
    let picker = UIPickerView()
    picker.delegate = self
    picker.dataSource = self
    return picker
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
    dismissKeyboardOnTap()
    
    // MARK: - tableView setup
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
//    tableView.rowHeight = UITableView.automaticDimension
    
    // MARK: - searchView setup
    searchView.locationField.delegate = self
    searchView.cuisineField.delegate = self
    searchView.priceField.delegate = self
    searchView.cuisineField.inputView = categoryPicker
    searchView.priceField.inputView = pricePicker
    
    // MARK: - subviews setup
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
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let detailsVC = RestaurantViewController(restaurantId: restaurants[indexPath.row].id)
    navigationController?.pushViewController(detailsVC, animated: true)
  }
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

extension DiscoverViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    if pickerView == categoryPicker {
      return Categories.allCases[row].rawValue
    } else {
      return Price.allCases[row].rawValue
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if pickerView == categoryPicker {
      searchView.cuisineField.text = Categories.allCases[row].rawValue
    } else {
      searchView.priceField.text = Price.allCases[row].rawValue
    }
    
    // TODO: set the current cuisine to the selected cuisine
  }
}

extension DiscoverViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    if pickerView == categoryPicker {
      return Categories.allCases.count
    } else {
      return Price.allCases.count
    }
  }
}

extension DiscoverViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    tableView.isUserInteractionEnabled = false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    tableView.isUserInteractionEnabled = true
  }
}
