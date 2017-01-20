//
//  PullRequestCell.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

class PullRequestCell: UITableViewCell {
  
  var pullRequest: PullRequest? {
    didSet {
      guard let pullRequest = pullRequest else {
        return
      }
      
      if let title = pullRequest.title {
        titleLabel.text = title
      }
      if let body = pullRequest.body {
        bodyLabel.text = body
      }
      if let dateString = pullRequest.createdAt, let date = dateString.dateFromISO8601 {
        dateLabel.text = date.stringFormat(format: "HH:MM - DD/MM/YYYY")
      }
      
      if let owner = pullRequest.user {
        if let name = owner.login {
          ownerNameLabel.text = name
        }
        if let avatarUrl = owner.avatarUrl, let url = URL(string: avatarUrl) {
          // sd image
          ownerAvatarImageView.sd_setImage(with: url) { [weak self] (img, err, _, _) in
            self?.activityIndicator.stopAnimating()
            if let img = img {
              self?.ownerAvatarImageView.image = img
            } else {
              self?.ownerAvatarImageView.image = #imageLiteral(resourceName: "repo_placeholder")
            }
          }
        }
      }
    }
  }
  
  @IBOutlet weak var ownerNameLabel: UILabel!
  @IBOutlet weak var ownerAvatarImageView: UIImageView!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var bodyLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

  override func awakeFromNib() {
    super.awakeFromNib()
    setupLayout()
  }
  
  func setupLayout () {
    ownerAvatarImageView.image = nil
  }
}
