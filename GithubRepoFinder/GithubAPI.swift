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
import ReachabilitySwift

class GithubAPI: NSObject {
  static let shared = GithubAPI()
  private override init () {}
  
  let reachability = Reachability()!
  
  var REPO_URL: String {
    return "https://api.github.com/search/repositories?q=language:\(language)&sort=star\(sort)&page=\(page)"
  }
  
  var githubApiDelegate: GithubApiDelegate?
  var pullRequestsDelegate: PullRequestsDelegate?
  
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
    
    if reachability.isReachable { // Internet connection Ok
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
    } else { // No internet connection
      // TODO: Make a core data request
    }
    
  } // loadRepos
  
  func loadPullRequests (repoName: String, page: Int = 1) {
    pullRequestsDelegate?.loadingPullRequests()
    
    if reachability.isReachable { // Internet connection Ok
      let PULL_REQUESTS_URL = "https://api.github.com/repos/\(repoName)/pulls?page=\(page)"
      Alamofire.request(PULL_REQUESTS_URL).responseArray { [weak self] (response: DataResponse<[PullRequest]>) in
        switch response.result {
        case .success(let pullRequests):
          self?.pullRequestsDelegate?.successfullyRetrieved(pullRequests: pullRequests)
          break
        case .failure(let error):
          self?.pullRequestsDelegate?.failedToRetrieve(with: error)
          break
        }
      }
    } else { // No internet connection
      // TODO: Make a core data request
    }
    
  } // loadPullRequests
  
  func loadNextPage () {
    page += page + 1
  }
}
