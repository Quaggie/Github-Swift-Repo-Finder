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
  var createdAt: Date?
  var body: String?
  var user: Owner?
  
  init?(map: Map) {
    g
  }
  
  mutating func mapping(map: Map) {
    id <- map["id"]
    url <- map["url"]
    title <- map["title"]
    createdAt <- map["createdAt"]
    body <- map["body"]
    user <- map["user"]
  }
}
