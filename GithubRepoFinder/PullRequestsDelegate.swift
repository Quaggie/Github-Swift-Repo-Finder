//
//  PullRequestsDelegate.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 20/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

protocol PullRequestsDelegate: class {
  func successfullyRetrieved (pullRequests: [PullRequest])
  func failedToRetrieve (with error: Error)
  func loadingPullRequests ()
}
