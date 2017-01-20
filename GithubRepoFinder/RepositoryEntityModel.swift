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
  @NSManaged var id: NSNumber? // Int16
  @NSManaged var name: String?
  @NSManaged var fullName: String?
  @NSManaged var owner: OwnerEntityModel?
  @NSManaged var desc: String?
  @NSManaged var stargazersCount: NSNumber? // Int16
  @NSManaged var forks: NSNumber? // In16
}
