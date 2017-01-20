//
//  OwnerEntityModel.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 20/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import CoreData

class OwnerEntityModel: NSManagedObject {
  @NSManaged var id: NSNumber? // Int16
  @NSManaged var login: String?
  @NSManaged var avatarUrl: String?
}
