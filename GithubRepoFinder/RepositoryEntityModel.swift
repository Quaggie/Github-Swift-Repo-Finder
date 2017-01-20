//
//  RepositoryEntityModel.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 20/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import CoreData

class RepositoryEntityModel: NSManagedObject {
  static var entityName: String {
    return "RepositoryEntity"
  }
  
  @NSManaged var id: NSNumber? // Int32
  @NSManaged var name: String?
  @NSManaged var fullName: String?
  @NSManaged var owner: OwnerEntityModel?
  @NSManaged var desc: String?
  @NSManaged var stargazersCount: NSNumber? // Int32
  @NSManaged var forks: NSNumber? // In32
}
