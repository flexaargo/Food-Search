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
      randomizeButtonPressed()
    }
  }
}

private extension DiscoverViewController {
  func setup() {
    title = "Discover"
    view.backgroundColor = .white
    dismissKeyboardOnTap()
    navigationItem.largeTitleDisplayMode = .always

    // MARK: - tableView setup
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
//    tableView.rowHeight = UITableView.automaticDimension

    // MARK: - searchView setup
    searchView.goBtn.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
    searchView.randomizeBtn.addTarget(self, action: #selector(randomizeButtonPressed), for: .touchUpInside)
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
    guard inputsVerified() else {
      return
    }
    let price = Price(rawValue: searchView.priceField.text!)!
    let category = Categories(rawValue: searchView.cuisineField.text!)!

    searchForRestaurants(withCategory: category, andPrice: price)
  }

  @objc func randomizeButtonPressed() {
    // Choose random category
    // Choose random price
    // Search for restaurants
    let price = Price.allCases[0...2].randomElement()!
    let category = Categories.allCases.randomElement()!

    searchView.cuisineField.text = category.rawValue
    searchView.priceField.text = price.rawValue

    searchForRestaurants(withCategory: category, andPrice: price)
  }

  func inputsVerified() -> Bool {
    return true
  }
}

// MARK: - Public Methods
extension DiscoverViewController {
  func onboardingFinished() {
    // TODO: Fill in location
  }
}

extension DiscoverViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let restaurant = restaurants[indexPath.row]
    let detailsVC = RestaurantViewController(restaurantId: restaurant.id, name: restaurant.name)
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
//      selectedCategory = Categories.allCases[row]
      searchView.cuisineField.text = Categories.allCases[row].rawValue
    } else {
//      selectedPrice = Price.allCases[row]
      searchView.priceField.text = Price.allCases[row].rawValue
    }
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

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
}
