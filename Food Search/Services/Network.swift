//
//  Network.swift
//  Food Search
//
//  Created by Alex Fargo on 5/10/19.
//  Copyright © 2019 Alex Fargo. All rights reserved.
//

import Foundation

protocol NetworkRequest: class {
  associatedtype Model
  func load(withCompletion completion: @escaping(Model?) -> Void)
  func decode(_ data: Data) -> Model?
}

extension NetworkRequest {
  fileprivate func load(_ urlRequest: URLRequest, withCompletion completion: @escaping(Model?) -> Void) {
//    let configuration = URLSessionConfiguration.ephemeral
//    let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, res, err) in
      guard let data = data else {
        print("Error fetching data: \(String(describing: err))")
        completion(nil)
        return
      }
      completion(self?.decode(data))
    }
    task.resume()
  }
}

class YelpApiRequest<Resource: YelpApiResource> {
  let resource: Resource
  
  init(resource: Resource) {
    self.resource = resource
  }
}

extension YelpApiRequest: NetworkRequest {
  func decode(_ data: Data) -> Resource.Model? {
    return resource.makeModel(data: data)
  }
  
  func load(withCompletion completion: @escaping (Resource.Model?) -> Void) {
    var urlRequest = URLRequest(url: resource.url)
    urlRequest.addValue("Bearer " + yApiKey, forHTTPHeaderField: "Authorization")
    load(urlRequest, withCompletion: completion)
  }
}

