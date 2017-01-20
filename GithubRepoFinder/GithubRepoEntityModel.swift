//
//  GithubRepoEntityModel.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 20/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import CoreData

class GithubRepoEntityModel: NSManagedObject {
  static var entityName: String {
    return "GithubRepoEntity"
  }
  
  @NSManaged var totalCount: NSNumber? // Int32
  @NSManaged var incompleteResults: NSNumber? // Boolean
  var isIncompleteResults: Bool {
    get {
      return Bool(incompleteResults ?? false)
    }
    set {
      incompleteResults = NSNumber(booleanLiteral: newValue)
    }
  }
  @NSManaged var items: [RepositoryEntityModel]?
}
