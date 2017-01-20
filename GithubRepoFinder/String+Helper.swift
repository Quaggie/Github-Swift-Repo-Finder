//
//  String+Helper.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 20/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

extension String {
  var dateFromISO8601: Date? {
    return Date.iso8601Formatter.date(from: self)
  }
}
