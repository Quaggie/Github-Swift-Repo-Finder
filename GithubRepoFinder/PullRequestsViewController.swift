//
//  PullRequestsViewController.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

class PullRequestsViewController: UIViewController {
  
  var repo: Repository?
  var currentPage: Int = 1
  var isFetching = false {
    didSet {
      if isFetching {
        tableView.isHidden = true
        if !activityIndicator.isAnimating {
          activityIndicator.startAnimating()
        }
      } else {
        tableView.isHidden = false
        activityIndicator.stopAnimating()
      }
    }
  }
  let reuseIdentifier = "PullRequestCell"

  var pullRequests: [PullRequest]? {
    didSet {
      guard pullRequests != nil else {
        return
      }
      tableView.reloadData()
    }
  }
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  class func instantiateFromStoryboard () -> PullRequestsViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PullRequestsViewController") as! PullRequestsViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupLayout()
    setupPullRequests()
    setupDelegates()
  }

}

// MARK: Setup
extension PullRequestsViewController {
  func setupPullRequests () {
    guard let repo = repo, let fullName = repo.fullName else {
      return
    }
    GithubAPI.shared.loadPullRequests(repoName: fullName)
  }
  
  func setupDelegates () {
    GithubAPI.shared.pullRequestsDelegate = self
  }
}

// MARK: Layout
extension PullRequestsViewController {
  func setupTableView () {
    tableView.isHidden = true
    tableView.delegate = self
    tableView.dataSource = self
    let nib = UINib(nibName: "PullRequestCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
  }
  
  func setupLayout () {
    activityIndicator.startAnimating()
    if let repo = repo, let name = repo.name {
      navigationItem.title = name
    }
  }
}

// MARK: UITableView Delegate & Datsource
extension PullRequestsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("IndexPath \(indexPath) selected")
    guard let pullRequests = pullRequests else {
      return
    }
    let pullRequest = pullRequests[indexPath.row]
    if let urlString = pullRequest.url, let url = URL(string: urlString) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        // Mensagem de erro falando que não pode abrir o url
      }
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 170.0
  }
}

extension PullRequestsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pullRequests?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let pullRequests = pullRequests,
      let pullRequestCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PullRequestCell
    else {
      return UITableViewCell()
    }
    pullRequestCell.pullRequest = pullRequests[indexPath.row]
    return pullRequestCell
  }
}

extension PullRequestsViewController: PullRequestsDelegate {
  func successfullyRetrieved(pullRequests: [PullRequest]) {
    isFetching = false
    self.pullRequests = pullRequests
  }
  
  func failedToRetrieve(with error: Error) {
    isFetching = false
    print(error)
  }
  
  func loadingPullRequests() {
    isFetching = true
  }
}
