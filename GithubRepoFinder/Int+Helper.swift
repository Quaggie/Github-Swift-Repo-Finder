//
//  Int+Helper.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

extension Int {
  var kFormatted: String {
    if self >= 1000 && self < 1000000 {
      return String(format: "%iK", self / 1000)
    } else if self >= 1000000 {
      return String(format: "%iM", self / 100000)
    } else {
      return String(describing: self)
    }
  }
}
