//
//  RepositoriesViewController.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

class RepositoriesViewController: UIViewController {
  
  let reuseIdentifier = "RepoCell"
  @IBOutlet weak var collectionView: UICollectionView!
  var githubRepo: GithubRepo? {
    didSet {
      collectionView.reloadData()
    }
  }
  var isFetching = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    setupDelegates()
  }
  
  func setupDelegates () {
    GithubAPI.shared.githubApiDelegate = self
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
    print("selected cell at \(indexPath)")
  }
}

extension RepositoriesViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let repoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? RepoCell {
      let repository = githubRepo?.items?[indexPath.item]
      repoCell.repository = repository
      
      if let githubRepo = githubRepo, let items = githubRepo.items, let totalCount = githubRepo.totalCount {
        if indexPath.item == items.count - 1 { // last cell
          if totalCount > items.count { // all cells
            if !isFetching {
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
    if let githubRepo = githubRepo, let items = githubRepo.items {
      return items.count
    }
    return 0
  }
}

extension RepositoriesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    print(view.frame.width)
    
    let maximumWidth: CGFloat = 375
    let cellHeight: CGFloat = 400
    
    switch UIDevice.current.orientation {
    case .portrait: fallthrough
    case .portraitUpsideDown: fallthrough
    case .faceUp: fallthrough
    case .faceDown:
      switch view.traitCollection.horizontalSizeClass {
        case .unspecified: fallthrough
      case .compact:
        return CGSize(width: view.frame.width, height: cellHeight)
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
  func successfullyRetrieved(githubRepo: GithubRepo) {
    isFetching = false
    if GithubAPI.shared.isFirstTime {
      self.githubRepo = githubRepo
    } else {
      if let items = githubRepo.items {
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

