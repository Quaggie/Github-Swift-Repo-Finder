//
//  Owner.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import ObjectMapper

struct Owner: Mappable {
  var id: Int?
  var login: String?
  var avatarUrl: String?
  
  static var entityName: String {
    return "OwnerEntity"
  }
  
  init?(map: Map) {
    
  }
  mutating func mapping(map: Map) {
    id <- map["id"]
    login <- map["login"]
    avatarUrl <- map["avatar_url"]
  }
}
