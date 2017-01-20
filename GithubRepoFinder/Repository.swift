//
//  Repository.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import ObjectMapper

struct Repository: Mappable {
  var id: Int?
  var name: String?
  var fullName: String?
  var owner: Owner?
  var description: String?
  var stargazersCount: Int?
  var forks: Int?
  
  init?(map: Map) {
    
  }
  mutating func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    fullName <- map["full_name"]
    owner <- map["owner"]
    description <- map["description"]
    stargazersCount <- map["stargazers_count"]
    forks <- map["forks"]
  }
}
