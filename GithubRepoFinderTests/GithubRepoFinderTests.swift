//
//  GithubRepoFinderTests.swift
//  GithubRepoFinderTests
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import XCTest
@testable import GithubRepoFinder

class GithubRepoFinderTests: XCTestCase {
  var repoVC: RepositoriesViewController?
  var pullRequestsVC: PullRequestsViewController?
    
  override func setUp() {
    super.setUp()
    repoVC = RepositoriesViewController.instantiateFromStoryboard()
    pullRequestsVC = PullRequestsViewController.instantiateFromStoryboard()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
  func testGithubApi () {
    XCTAssert(GithubAPI.shared.page == 1, "Page should start with 1")
    XCTAssert(GithubAPI.shared.isFirstTime == true, "isFirstTime should be true on load")
    
    GithubAPI.shared.loadNextPage()
    
    XCTAssert(GithubAPI.shared.isFirstTime == false, "isFirstTime(\(GithubAPI.shared.page)) should be false")
    
  }
  
  func testCoreDataManager () {
    // TODO
  }
    
}
