//
//  Defaults.swift
//  Food Search
//
//  Created by Alex Fargo on 5/20/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import Foundation

struct Defaults {
  static let favoritesKey = "xyz.alexfargo.foodsearch.favorites"
  static let onboardingKey = "xyz.alexfargo.foodsearch.onboarding"
  static let backupLocation = "xyz.alexfargo.foodsearch.backuplocation"
  
  static func save(restaurantId: String) {
    var favorites = getRestaurants()
    favorites.append(restaurantId)
    UserDefaults.standard.set(favorites, forKey: favoritesKey)
  }
  
  static func getRestaurants() -> [String] {
    let favorites = UserDefaults.standard.value(forKey: favoritesKey) as? [String] ?? []
    return favorites
  }
  
  static func restaurantIsSaved(_ restaurantId: String) -> Bool {
    let favorites = getRestaurants()
    return favorites.contains(restaurantId)
  }
  
  static func remove(restaurantId: String) {
    guard restaurantIsSaved(restaurantId) else {
      return
    }
    
    var favorites = getRestaurants()
    favorites = favorites.filter { $0 != restaurantId }
    UserDefaults.standard.set(favorites, forKey: favoritesKey)
  }
  
  static func setOnboardingPage(_ page: Int) {
    UserDefaults.standard.set(page, forKey: onboardingKey)
  }
  
  static func currentOnboardingPage() -> Int {
    return UserDefaults.standard.value(forKey: onboardingKey) as? Int ?? 1
  }
  
  static func saveBackupLocation(locationString: String) {
    UserDefaults.standard.set(locationString, forKey: backupLocation)
  }
  
  static func getBackupLocation() -> String {
    return UserDefaults.standard.value(forKey: backupLocation) as? String ?? ""
  }
}
