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
  private(set) var fetchedFromServer = true
  let language = "Swift"
  let sort = "stars"
  
  func loadRepos () {
    githubApiDelegate?.loadingRepos()
    
    if reachability.isReachable { // Internet connection Ok
      Alamofire.request(REPO_URL).responseObject { [weak self] (response: DataResponse<GithubRepo>) in
        self?.fetchedFromServer = true
        switch response.result {
        case .success(let githubRepo):
          CoreDataManager.shared.saveGithubRepo(githubRepo: githubRepo)
          self?.githubApiDelegate?.successfullyRetrieved(githubRepo: githubRepo)
          break
        case .failure(let error):
          self?.githubApiDelegate?.failedToRetrieve(with: error)
          break
        }
      }
    } else { // No internet connection
      if let githubRepo = CoreDataManager.shared.fetchGithubRepo() {
        fetchedFromServer = false
        githubApiDelegate?.successfullyRetrieved(githubRepo: githubRepo)
      }
    }
    
  } // loadRepos
  
  func loadPullRequests (repo: Repository, page: Int = 1) {
    guard let fullName = repo.fullName else {
      return
    }
    pullRequestsDelegate?.loadingPullRequests()
    
    if reachability.isReachable { // Internet connection Ok
      let PULL_REQUESTS_URL = "https://api.github.com/repos/\(fullName)/pulls?page=\(page)"
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
      if let pullRequests = CoreDataManager.shared.fetchPullRequests(for: repo) {
        pullRequestsDelegate?.successfullyRetrieved(pullRequests: pullRequests)
      }
    }
    
  } // loadPullRequests
  
  func loadNextPage () {
    page += page + 1
  }
}
