//
//  DiscoverViewController.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import UIKit
import CoreLocation

class DiscoverViewController: UIViewController {
  
  private var restaurants: [YRestaurantSimple] = []
  private var request: AnyObject?
  
  private var locationManager = CLLocationManager()
  private var canUseLocation: Bool {
    let status = CLLocationManager.authorizationStatus()
    if status != .denied || status != .notDetermined || status != .restricted
      && CLLocationManager.locationServicesEnabled() {
      return true
    }
    return false
  }
  private var locationRetrieved = false
  private var locationError = false
  
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
    let currentOnboardingPage = Defaults.currentOnboardingPage()
    if currentOnboardingPage == 3 {
      let page = OnboardingPageThree()
      page.discoverViewController = self
      self.parent!.present(page, animated: false, completion: nil)
    } else if currentOnboardingPage == 2 {
      let page = OnboardingPageTwo()
      page.discoverViewController = self
      self.parent!.present(page, animated: false, completion: nil)
    } else if currentOnboardingPage == 1 {
      let page = OnboardingPageOne()
      page.discoverViewController = self
      self.parent!.present(page, animated: false, completion: nil)
    } else {
      appLaunch()
    }
  }
}

// MARK: - Private Methods
private extension DiscoverViewController {
  func appLaunch() {
    randomizeButtonPressed()
  }
  
  func setup() {
    title = "Discover"
    view.backgroundColor = .white
    dismissKeyboardOnTap()
    navigationItem.largeTitleDisplayMode = .always
    
    // MARK: Location Manager Setup
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    
    // MARK: Table View Setup
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    
    // MARK: Search View Setup
    searchView.goBtn.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
    searchView.randomizeBtn.addTarget(self, action: #selector(randomizeButtonPressed), for: .touchUpInside)
    
    searchView.locationField.delegate = self
    
    searchView.cuisineField.delegate = self
    searchView.cuisineField.inputView = categoryPicker
    
    searchView.priceField.delegate = self
    searchView.priceField.inputView = pricePicker
    
    // MARK: Subviews Setup
    setupSubviews()
  }
  
  func setupSubviews() {
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
  
  func searchForRestaurants(withCategory category: Categories, andPrice price: Price) {
    let category = category.alias
    let price = price.param
    var searchResultsResource = SearchResultsResource()
    searchResultsResource.params = [
      "location=Chino%20Hills",
      "categories=\(category)",
      "price=\(price)",
      "open_now=true"
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
  
  @objc func goButtonPressed() {
    verifyInputs()
    
    let price = Price(rawValue: searchView.priceField.text!)!
    let category = Categories(rawValue: searchView.cuisineField.text!)!
    
    searchForRestaurants(withCategory: category, andPrice: price)
  }
  
  @objc func randomizeButtonPressed() {
    verifyInputs()
    
    let price = Price.allCases[0...2].randomElement()!
    let category = Categories.allCases.randomElement()!
    
    searchView.cuisineField.text = category.rawValue
    searchView.priceField.text = price.rawValue
    
    searchForRestaurants(withCategory: category, andPrice: price)
  }
  
  func verifyInputs() {
    let locationField = searchView.locationField
    if locationField.text! == "Current Location" {
      if !canUseLocation {
        searchView.setLocationFieldToBackupLocation()
      }
    }
    
    if locationField.text!.isEmpty {
      if canUseLocation {
        searchView.setLocationFieldToCurrentLocation()
      } else {
        searchView.setLocationFieldToBackupLocation()
      }
    }
  }
}

// MARK: - Public Methods
extension DiscoverViewController {
  func onboardingFinished() {
    randomizeButtonPressed()
  }
}

// MARK: - Table View Delegate Methods
extension DiscoverViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let restaurant = restaurants[indexPath.row]
    let detailsVC = RestaurantViewController(restaurantId: restaurant.id, name: restaurant.name)
    navigationController?.pushViewController(detailsVC, animated: true)
  }
}

// MARK: - Table View Data Source Methods
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

// MARK: - Picker View Delegate Methods
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
      //      selectedCategory = Categories.allCases[row]
      searchView.cuisineField.text = Categories.allCases[row].rawValue
    } else {
      //      selectedPrice = Price.allCases[row]
      searchView.priceField.text = Price.allCases[row].rawValue
    }
  }
}

// MARK: - Picker View Data Source Methods
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

// MARK: - Text Field Delegate Methods
extension DiscoverViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    tableView.isUserInteractionEnabled = false
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    tableView.isUserInteractionEnabled = true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}

// MARK: - Location Manager Delegate Methods
extension DiscoverViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
  }
}
