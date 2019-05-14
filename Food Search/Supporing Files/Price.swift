//
//  Price.swift
//  Food Search
//
//  Created by Alex Fargo on 5/13/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import Foundation

enum Price: String, CaseIterable {
  case one = "$"
  case two = "$$"
  case three = "$$$"
  case four =  "$$$$"
  
  var param: Int {
    switch self {
    case .one:
      return 1
    case .two:
      return 2
    case .three:
      return 3
    case .four:
      return 4
    }
  }
}
