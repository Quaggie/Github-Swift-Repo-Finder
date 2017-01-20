//
//  RepoCell.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import SDWebImage

class RepoCell: UICollectionViewCell {
  
  var repository: Repository? {
    didSet {
      guard let repository = repository else {
        return
      }
      layer.cornerRadius = 5.0
      layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
      layer.borderWidth = 1.0
      
      
      if let name = repository.name {
        nameLabel.text = name
      } else {
        nameLabel.text = "N/D"
      }
      if let description = repository.description {
        descriptionLabel.text = description
      } else {
        descriptionLabel.text = "..."
      }
      if let stargazersCount = repository.stargazersCount {
        stargazersCountLabel.text = "\(stargazersCount)"
      } else {
        stargazersCountLabel.text = "0"
      }
      if let forks = repository.forks {
        forksLabel.text = "\(forks)"
      } else {
        forksLabel.text = "0"
      }
      
      if let owner = repository.owner {
        if let login = owner.login {
          loginLabel.text = login
        } else {
          loginLabel.text = "..."
        }
        if let avatarUrl = owner.avatarUrl, let url = URL(string: avatarUrl) {
          // sd image
          avatarUrlImageView.sd_setImage(with: url) { [weak self] (img, err, _, _) in
            self?.activityIndicator.stopAnimating()
            if let img = img {
              self?.avatarUrlImageView.image = img
            } else {
              self?.avatarUrlImageView.image = #imageLiteral(resourceName: "repo_placeholder")
            }
          }
        } else {
          avatarUrlImageView.image = #imageLiteral(resourceName: "repo_placeholder")
        }
      }
    }
  }
  
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var avatarUrlImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var gradientView: UIView!
  
  @IBOutlet weak var stargazersImageView: UIImageView!
  @IBOutlet weak var stargazersCountLabel: UILabel!
  
  @IBOutlet weak var forksImageView: UIImageView!
  @IBOutlet weak var forksLabel: UILabel!
 
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
}
