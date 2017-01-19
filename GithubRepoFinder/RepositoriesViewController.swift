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
    flowLayout.minimumLineSpacing = 8
    flowLayout.minimumInteritemSpacing = 8
    
    collectionView.setCollectionViewLayout(flowLayout, animated: true)
  }
}

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
    return CGSize(width: 328, height: 429)
  }
}

// MARK: GithubApi Delegate
extension RepositoriesViewController: GithubApiDelegate{
  func successfullyRetrieved(githubRepo: GithubRepo) {
//    print(githubRepo)
    self.githubRepo = githubRepo
  }
  
  func failedToRetrieve(with error: Error) {
//    print(error)
  }
}

