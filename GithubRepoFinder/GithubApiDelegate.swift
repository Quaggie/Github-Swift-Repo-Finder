//
//  GithubApiDelegate.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

protocol GithubApiDelegate: class {
  func successfullyRetrieved (githubRepo: GithubRepo)
  func failedToRetrieve (with error: Error)
}
