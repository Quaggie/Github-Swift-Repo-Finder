//
//  GithubAPI.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

class GithubAPI: NSObject {
  static let shared = GithubAPI()
  private override init () {}
  
  var totalCount: Int = 0
  var page: Int = 0
  
  
}
