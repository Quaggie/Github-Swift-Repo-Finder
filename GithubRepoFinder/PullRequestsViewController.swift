//
//  PullRequestsViewController.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import ReachabilitySwift

class PullRequestsViewController: UIViewController {
  
  var repo: Repository?
  var currentPage: Int = 1
  var reachability = Reachability()!
  var fetchedFromServer = false
  
  var isFetching = false {
    didSet {
      if isFetching {
        tableView.isHidden = true
        noPullRequestsView.isHidden = true
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
      if let pullRequests = pullRequests {
        if pullRequests.count > 0 {
          noPullRequestsView.isHidden = true
          tableView.reloadData()
        } else {
          noPullRequestsView.isHidden = false
          if fetchedFromServer {
            labelMessage.text = "Não há Pull Requests neste repositório"
          } else {
            labelMessage.text = "Não há dados armazenados para este Pull Request"
          }
        }
      }
    }
  }
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noPullRequestsView: UIView!
  
  @IBOutlet weak var labelMessage: UILabel!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  class func instantiateFromStoryboard () -> PullRequestsViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PullRequestsViewController") as! PullRequestsViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDelegates()
    setupTableView()
    setupLayout()
    setupPullRequests()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  func fetchFreshDataIfNeeded () {
    if let repo = repo, !isFetching, !fetchedFromServer {
      GithubAPI.shared.loadPullRequests(repo: repo)
    }
  }

}

// MARK: Setup
extension PullRequestsViewController {
  func setupPullRequests () {
    guard let repo = repo else {
      return
    }
    GithubAPI.shared.loadPullRequests(repo: repo)
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
    guard let pullRequests = pullRequests else {
      return
    }
    let pullRequest = pullRequests[indexPath.row]
    if let urlString = pullRequest.url, let url = URL(string: urlString) {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.openURL(url)
      }
    }
    tableView.deselectRow(at: indexPath, animated: true)
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
  func successfullyRetrieved(pullRequests: [PullRequest]?, fetchedFromServer: Bool) {
    isFetching = false
    self.fetchedFromServer = fetchedFromServer
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

// MARK: Observers
extension PullRequestsViewController {
  func addObservers () {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(reachabilityChanged),
                                           name: ReachabilityChangedNotification,
                                           object: reachability)
    do{
      try reachability.startNotifier()
    } catch {
      print("Could not start reachability notifier")
    }
  }
  
  func removeObservers () {
    reachability.stopNotifier()
    NotificationCenter.default.removeObserver(self,
                                              name: ReachabilityChangedNotification,
                                              object: reachability)
  }
  
  func reachabilityChanged (notification: Notification) {
    guard let reachability = notification.object as? Reachability else {
      return
    }
    
    if reachability.isReachable {
      fetchFreshDataIfNeeded()
    } else {
      print("Network not reachable")
    }
  }
}
