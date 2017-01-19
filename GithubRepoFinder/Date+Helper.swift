//
//  Date+Helper.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

extension Date {
  func stringFormat (format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: self)
  }
}
