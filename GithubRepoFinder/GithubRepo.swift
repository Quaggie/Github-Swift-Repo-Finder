//
//  GithubRepo.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import ObjectMapper

struct GithubRepo: Mappable {
  
  var totalCount: Int?
  var incompleteResults: Bool?
  var items: [Repository]?
  
  init?(map: Map) {
    
  }
  mutating func mapping(map: Map) {
    totalCount <- map["total_count"]
    incompleteResults <- map["incomplete_results"]
    items <- map["items"]
  }
}

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

struct Owner: Mappable {
  var id: Int?
  var login: String?
  var avatarUrl: String?
  
  init?(map: Map) {
    
  }
  mutating func mapping(map: Map) {
    id <- map["id"]
    login <- map["login"]
    avatarUrl <- map["avatar_url"]
  }
}
