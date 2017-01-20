//
//  GithubAPI.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class GithubAPI: NSObject {
  static let shared = GithubAPI()
  private override init () {}
  
  var REPO_URL: String {
    return "https://api.github.com/search/repositories?q=language:\(language)&sort=star\(sort)&page=\(page)"
  }
  
  var githubApiDelegate: GithubApiDelegate?
  private(set) var isFirstTime = true
  private(set) var page: Int = 1 {
    didSet {
      if page > 1, isFirstTime == true {
        isFirstTime = false
      }
      loadRepos()
    }
  }
  let language = "Swift"
  let sort = "stars"
  
  func loadRepos () {
    githubApiDelegate?.loadingRepos()
    Alamofire.request(REPO_URL).responseObject { [weak self] (response: DataResponse<GithubRepo>) in
      switch response.result {
      case .success(let githubRepo):
        self?.githubApiDelegate?.successfullyRetrieved(githubRepo: githubRepo)
        break
      case .failure(let error):
        self?.githubApiDelegate?.failedToRetrieve(with: error)
        break
      }
    }
  } // loadRepos
  
  func loadNextPage () {
    page += page + 1
  }
}
