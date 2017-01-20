//
//  PullRequest.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import ObjectMapper

struct PullRequest: Mappable {
  var id: Int?
  var url: String?
  var title: String?
  var createdAt: String?
  var body: String?
  var user: Owner?
  
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    url <- map["html_url"]
    title <- map["title"]
    createdAt <- map["created_at"]
    body <- map["body"]
    user <- map["user"]
  }
}
