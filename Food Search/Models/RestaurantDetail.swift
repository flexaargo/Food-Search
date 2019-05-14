//
//  RestaurantDetail.swift
//  Food Search
//
//  Created by Alex Fargo on 5/13/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import Foundation

struct DetailHeader {
  var name: String
  var reviewCount: Int
  var rating: Double
  var price: String?
  var categories: [Category]
  var hours: [Hours]
}
