//
//  RepositoriesViewController.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import ReachabilitySwift

class RepositoriesViewController: UIViewController {
  
  let reachability = Reachability()!
  let reuseIdentifier = "RepoCell"
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var noReposView: UIView!
  
  var githubRepo: GithubRepo? {
    didSet {
      guard let githubRepo = githubRepo else {
        noReposView.isHidden = false
        return
      }
      if let items = githubRepo.items, items.count > 0 {
        noReposView.isHidden = true
        collectionView.reloadData()
      } else {
        noReposView.isHidden = false
      }
    }
  }
  var isFetching = false
  
  class func instantiateFromStoryboard () -> RepositoriesViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RepositoriesViewController") as! RepositoriesViewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupDelegates()
    setupRepos()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    addObservers()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  
  func setupDelegates () {
    GithubAPI.shared.githubApiDelegate = self
  }
  
  func setupRepos () {
    GithubAPI.shared.loadRepos()
  }
  
  func fetchFreshDataIfNeeded () {
    if !isFetching, !GithubAPI.shared.fetchedFromServer {
      GithubAPI.shared.loadRepos()
    }
  }
}

// MARK: Setup collection view
extension RepositoriesViewController {
  func setupCollectionView () {
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let repoNib = UINib(nibName: "RepoCell", bundle: nil)
    collectionView.register(repoNib, forCellWithReuseIdentifier: reuseIdentifier)
    
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    collectionView.setCollectionViewLayout(flowLayout, animated: true)
  }
}

// MARK: UICollectionView Delegate, Datasrouce, DelegateFlowLayout
extension RepositoriesViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let githubRepo = githubRepo, let items = githubRepo.items else {
      return
    }
    let repo = items[indexPath.row]
    let pullRequestsVC = PullRequestsViewController.instantiateFromStoryboard()
    pullRequestsVC.repo = repo
    navigationController?.pushViewController(pullRequestsVC, animated: true)
  }
}

extension RepositoriesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let repoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RepoCell {
      let repository = githubRepo?.items?[indexPath.item]
      repoCell.repository = repository
      
      if let githubRepo = githubRepo, let items = githubRepo.items, let totalCount = githubRepo.totalCount { // Unwrapping
        if indexPath.item == items.count - 1 { // last cell
          if totalCount > items.count { // all cells
            if !isFetching, reachability.isReachable { // Verify if it isn't already loading
              GithubAPI.shared.loadNextPage()
            }
          }
        }
      }
      
      return repoCell
    }
    return UICollectionViewCell()
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return githubRepo?.items?.count ?? 0
  }
}

extension RepositoriesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let maximumWidth: CGFloat = 375
    let cellHeight: CGFloat = 400
    let sideInsets: CGFloat = 16
    
    switch UIDevice.current.orientation {
    case .portrait: fallthrough
    case .portraitUpsideDown: fallthrough
    case .faceUp: fallthrough
    case .faceDown:
      switch view.traitCollection.horizontalSizeClass {
        case .unspecified: fallthrough
      case .compact:
        return CGSize(width: view.frame.width - sideInsets, height: cellHeight)
      case .regular:
        return CGSize(width: maximumWidth, height: cellHeight)
      }
    case .landscapeLeft: fallthrough
    case .landscapeRight:
      return CGSize(width: maximumWidth, height: cellHeight)
    default: return CGSize(width: view.frame.width, height: cellHeight)
    }
  }
}

// MARK: GithubApi Delegate
extension RepositoriesViewController: GithubApiDelegate {
  func successfullyRetrieved(githubRepo: GithubRepo?) {
    isFetching = false
    if GithubAPI.shared.isFirstTime {
      self.githubRepo = githubRepo
    } else {
      if let items = githubRepo?.items {
        self.githubRepo?.items?.append(contentsOf: items)
      }
    }
  }
  
  func failedToRetrieve(with error: Error) {
    isFetching = false
  }
  
  func loadingRepos () {
    isFetching = true
  }
}

// MARK: Observers
extension RepositoriesViewController {
  
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









