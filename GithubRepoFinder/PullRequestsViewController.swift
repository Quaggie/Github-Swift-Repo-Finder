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

  var pullRequests: [PullRequest]? {
    didSet {
      guard pullRequests != nil else {
        return
      }
      tableView.reloadData()
    }
  }
  @IBOutlet weak var tableView: UITableView!
  
  class func instantiateFromStoryboard () -> PullRequestsViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PullRequestsViewController") as! PullRequestsViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    setupLayout()
  }

}

// MARK: Layout
extension PullRequestsViewController {
  func setupTableView () {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func setupLayout () {
    if let repo = repo, let name = repo.name {
      navigationItem.title = name
    }
  }
}

// MARK: UITableView Delegate & Datsource
extension PullRequestsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("IndexPath \(indexPath) selected")
  }
}

extension PullRequestsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return pullRequests?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }
}
