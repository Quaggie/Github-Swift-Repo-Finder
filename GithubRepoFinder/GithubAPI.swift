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
  
  let REPO_URL = "https://api.github.com/search/repositories?q=language:Swift&sort=stars&page=1"
  
  var githubApiDelegate: GithubApiDelegate?
  var totalCount: Int = 0
  var page: Int = 0
  
  func loadRepos () {
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
}
