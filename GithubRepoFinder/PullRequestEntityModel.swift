//
//  PullRequestEntityModel.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 20/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import CoreData

class PullRequestEntityModel: NSManagedObject {
  static var entityName: String {
    return "PullRequestEntity"
  }
  
  @NSManaged var id: NSNumber // Int32
  @NSManaged var url: String?
  @NSManaged var title: String?
  @NSManaged var createdAt: String?
  @NSManaged var body: String?
  @NSManaged var user: OwnerEntityModel?
}
