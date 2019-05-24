//
//  YResturant.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import Foundation

struct YSearchResult {
  let count: Int
  let restaurants: [YRestaurantSimple]
}

extension YSearchResult: Decodable {
  enum CodingKeys: String, CodingKey {
    case count = "total"
    case restaurants = "businesses"
  }
}

struct YRestaurantSimple {
  let id: String
  let alias: String
  let name: String
  let imageURL: String
  let isClosed: Bool
  let reviewCount: Int
  let rating: Double
  let coordinates: Coordinates
  let location: Location
  let distance: Double
}

extension YRestaurantSimple: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case alias
    case name
    case imageURL = "image_url"
    case isClosed = "is_closed"
    case reviewCount = "review_count"
    case rating
    case coordinates
    case location
    case distance
  }
}

struct YRestaurantDetail {
  let id: String
  let alias: String
  let name: String
  let imageURL: String
  let isClosed: Bool
  let url: String
  let price: String?
  let phone: String
  let displayPhone: String
  let categories: [Category]
  let reviewCount: Int
  let rating: Double
  let coordinates: Coordinates
  let location: Location
  let photoURLs: [String]
  let hours: [Hours]
  let isOpenNow: Bool
  var distance: Double?
}

extension YRestaurantDetail: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case alias
    case name
    case imageURL = "image_url"
    case isClosed = "is_closed"
    case url
    case price
    case phone
    case displayPhone = "display_phone"
    case categories
    case reviewCount = "review_count"
    case rating
    case coordinates
    case location
    case photoURLs = "photos"
    // Nested array object
    case hours
    enum HoursKeys: String, CodingKey {
      // Nested array object
      case openHours = "open"
      case isOpenNow = "is_open_now"
      enum OpenHoursKeys: String, CodingKey {
        case hours
      }
    }
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(String.self, forKey: .id)
    self.alias = try container.decode(String.self, forKey: .alias)
    self.name = try container.decode(String.self, forKey: .name)
    self.imageURL = try container.decode(String.self, forKey: .imageURL)
    self.isClosed = try container.decode(Bool.self, forKey: .isClosed)
    self.url = try container.decode(String.self, forKey: .url)
    self.price = try container.decodeIfPresent(String.self, forKey: .price)
    self.phone = try container.decode(String.self, forKey: .phone)
    self.displayPhone = try container.decode(String.self, forKey: .displayPhone)
    self.categories = try container.decode([Category].self, forKey: .categories)
    self.reviewCount = try container.decode(Int.self, forKey: .reviewCount)
    self.rating = try container.decode(Double.self, forKey: .rating)
    self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
    self.location = try container.decode(Location.self, forKey: .location)
    self.photoURLs = try container.decode([String].self, forKey: .photoURLs)
    
    // Decodes the nested objects in hours:[{open:[{},{},...]}]
    var hoursContainer = try container.nestedUnkeyedContainer(forKey: .hours)
    let openHoursContainer = try hoursContainer.nestedContainer(keyedBy: CodingKeys.HoursKeys.self)
    self.isOpenNow = try openHoursContainer.decode(Bool.self, forKey: .isOpenNow)
    hoursContainer = try openHoursContainer.nestedUnkeyedContainer(forKey: .openHours)
    var hours: [Hours] = []
    while !hoursContainer.isAtEnd {
      let openHours = try hoursContainer.decode(Hours.self)
      hours.append(openHours)
    }
    self.hours = hours
  }
}

struct YRestaurantReviews {
  let reviews: [YRestaurantReview]
}

extension YRestaurantReviews: Decodable {
  enum CodingKeys: String, CodingKey {
    case reviews
  }
}

struct YRestaurantReview {
  let id: String
  let url: String
  let text: String
  let rating: Double
  let timeCreated: String
  let user: YUser
}

extension YRestaurantReview: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case url
    case text
    case rating
    case timeCreated = "time_created"
    case user
  }
}

struct YUser {
  let id: String
  let profileURL: String
  let imageURL: String
  let name: String
}

extension YUser: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case profileURL = "profile_url"
    case imageURL = "image_url"
    case name
  }
}

struct Coordinates {
  let latitude: Double
  let longitude: Double
}

extension Coordinates: Decodable {
  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
  }
}

struct Location {
  let address1: String?
  let address2: String?
  let address3: String?
  let city: String
  let zipCode: String
  let country: String
  let state: String
  let displayAddress: [String]
}

extension Location: Decodable {
  enum CodingKeys: String, CodingKey {
    case address1
    case address2
    case address3
    case city
    case zipCode = "zip_code"
    case country
    case state
    case displayAddress = "display_address"
  }
}

struct Category {
  let alias: String
  let title: String
}

extension Category: Decodable {
  enum CodingKeys: String, CodingKey {
    case alias
    case title
  }
}

struct Hours {
  let isOvernight: Bool
  let start: String
  let end: String
  let day: Int
}

extension Hours: Decodable {
  enum CodingKeys: String, CodingKey {
    case isOvernight = "is_overnight"
    case start
    case end
    case day
  }
}
