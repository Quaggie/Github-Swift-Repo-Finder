//
//  GithubRepo.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import ObjectMapper

struct GithubRepo: Mappable {
  
  var totalCount: Int?
  var incompleteResults: Bool?
  var items: [Repository]?
  
  static var entityName: String {
    return "GithubRepoEntity"
  }
  
  init?(map: Map) {
    
  }
  mutating func mapping(map: Map) {
    totalCount <- map["total_count"]
    incompleteResults <- map["incomplete_results"]
    items <- map["items"]
  }
}
