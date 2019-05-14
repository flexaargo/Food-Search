//
//  Service.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import Foundation

protocol YelpApiResource {
  associatedtype Model: Decodable
  var methodPath: String { get }
  var params: [String] { get set }
  func makeModel(data: Data) -> Model?
}

extension YelpApiResource {
  var url: URL {
    let baseUrl = "https://api.yelp.com/v3/"
    var url = baseUrl + methodPath
    if params.count > 0 {
      url += "?"
      params.map({$0 + "&"}).forEach({url += $0})
    }
    return URL(string: url)!
  }
  
  func makeModel(data: Data) -> Model? {
    do {
      let result = try JSONDecoder().decode(Model.self, from: data)
      return result
    } catch {
      return nil
    }
  }
}

struct SearchResultsResource: YelpApiResource {
  typealias Model = YSearchResult
  
  let methodPath = "businesses/search"
  var params: [String] = []
}

struct RestaurantDetailResource: YelpApiResource {
  typealias Model = YRestaurantDetail
  
  var id: String!
  var methodPath: String {
    return "search/" + id
  }
  var params: [String] = []
}

public class Service {
  
}
