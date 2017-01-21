//
//  AppDelegate.swift
//  CoreDataManager
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
  static let shared = CoreDataManager()
  
  private override init () {}
  
  func saveGithubRepo (githubRepo: GithubRepo?) {
    guard let githubRepo = githubRepo else {
      return
    }
    
    let githubRepoFetchRequest = NSFetchRequest<GithubRepoEntity>(entityName: GithubRepo.entityName)
    
    var githubRepoEntityModel: NSManagedObject?
    
    if let githubRepoEntity = NSEntityDescription.entity(forEntityName: GithubRepo.entityName, in: managedObjectContext) {
      githubRepoEntityModel = NSManagedObject(entity: githubRepoEntity, insertInto: managedObjectContext)
    }
    
    do {
      let results = try managedObjectContext.fetch(githubRepoFetchRequest)
      
      if results.count > 1 {
        // Removing the all uneeded objects
        results.forEach { managedObjectContext.delete($0) }
      } else {
        // Grabbing the model if it already exists
        if let first = results.first, results.count == 1 {
          githubRepoEntityModel = first
        }
      }
    } catch {
      print("Error on deleting github repos")
    }
    
    githubRepoEntityModel?.setValue(githubRepo.totalCount, forKey: "totalCount")
    githubRepoEntityModel?.setValue(githubRepo.incompleteResults, forKey: "incompleteResults")
    
    let repos = NSMutableSet()
    githubRepo.items?.forEach{ repo in
      if let repositoryEntity = NSEntityDescription.entity(forEntityName: Repository.entityName, in: managedObjectContext) {
        let repositoryEntityModel = NSManagedObject(entity: repositoryEntity, insertInto: managedObjectContext)
        repositoryEntityModel.setValue(repo.id, forKey: "id")
        repositoryEntityModel.setValue(repo.name, forKey: "name")
        repositoryEntityModel.setValue(repo.fullName, forKey: "fullName")
        repositoryEntityModel.setValue(repo.desc, forKey: "desc")
        repositoryEntityModel.setValue(repo.stargazersCount, forKey: "stargazersCount")
        repositoryEntityModel.setValue(repo.forks, forKey: "forks")
        
        if let ownerEntity = NSEntityDescription.entity(forEntityName: Owner.entityName, in: managedObjectContext) {
          let ownerEntityModel = NSManagedObject(entity: ownerEntity, insertInto: managedObjectContext)
          ownerEntityModel.setValue(repo.owner?.id, forKey: "id")
          ownerEntityModel.setValue(repo.owner?.login, forKey: "login")
          ownerEntityModel.setValue(repo.owner?.avatarUrl, forKey: "avatarUrl")
          
          repositoryEntityModel.setValue(ownerEntityModel, forKey: "owner")
        } // ownerEntity
        repos.add(repositoryEntityModel)
      } // repositoryEntity
      
      // If it's the first, add everything to the objects
      if GithubAPI.shared.isFirstTime {
        githubRepoEntityModel?.setValue(repos, forKey: "items")
      } else { // Only append to the original model for the pagination to work normally
        if let items = githubRepoEntityModel?.value(forKey: "items") as? NSSet {
          var allObjects = items.allObjects
          allObjects.append(contentsOf: repos)
          githubRepoEntityModel?.setValue(NSSet(array: allObjects), forKey: "items")
        }
      }
    } // forEach
    
    saveContext()
  }
  
  func fetchGithubRepo (page: Int = 1, limit: Int = 30) -> GithubRepo? {
    let githubRepoFetchRequest = NSFetchRequest<GithubRepoEntity>(entityName: GithubRepo.entityName)
    githubRepoFetchRequest.fetchLimit = 1
    
    do {
      let githubRepos = try managedObjectContext.fetch(githubRepoFetchRequest)
      if let githubRepo = githubRepos.first {
        
        var githubRepoJson: [String: Any] = [
          "total_count" : Int(githubRepo.totalCount),
          "incomplete_results": githubRepo.incompleteResults,
        ]

        if let items = githubRepo.items, let objects = items.allObjects as? [RepositoryEntity] {
          // Sorting by github stars
          let sortedObjects = objects.sorted(by: { (prev, curr) -> Bool in
            return prev.stargazersCount > curr.stargazersCount
          })
          
          let repos = sortedObjects.map { repo -> [String: Any?] in
            var repoJson: [String: Any?] = [:]
            
            repoJson["id"] = Int(repo.id)
            
            if let name = repo.name {
              repoJson["name"] = name
            }
            if let fullName = repo.fullName {
              repoJson["full_name"] = fullName
            }
            if let desc = repo.desc {
              repoJson["description"] = desc
            }
            repoJson["stargazers_count"] = Int(repo.stargazersCount)
            repoJson["forks"] = Int(repo.forks)
            
            if let owner = repo.owner {
              var ownerJson: [String: Any?] = [:]
              
              ownerJson["id"] = Int(owner.id)
              if let login = owner.login {
                ownerJson["login"] = login
              }
              if let avatarUrl = owner.avatarUrl {
                ownerJson["avatar_url"] = avatarUrl
              }
              
              repoJson["owner"] = ownerJson
            }
            return repoJson
          }
          githubRepoJson["items"] = repos
        }
        return GithubRepo(JSON: githubRepoJson)
      }
    } catch let error as NSError {
      print("Error \(error.localizedDescription) with userinfo -> \(error.userInfo)")
    }
    return nil
  }
  
  func savePullRequests (repo: Repository?, pullRequests: [PullRequest]?) {
    guard let repo = repo, let pullRequests = pullRequests else {
      return
    }
    let pullRequestsFetchRequest = NSFetchRequest<PullRequestEntity>(entityName: PullRequest.entityName)
    if let repoId = repo.id {
      let predicate = NSPredicate(format: "repoId = %@", "\(repoId)")
      
      pullRequestsFetchRequest.predicate = predicate
    }
    
    do {
      let pullRequestEntities = try managedObjectContext.fetch(pullRequestsFetchRequest)

      pullRequestEntities.forEach { managedObjectContext.delete($0) }
    } catch {
      print("Couldn't fetch PullRequestEntity")
    }
    
    pullRequests.forEach { pullRequest in
      if let pullRequestEntity = NSEntityDescription.entity(forEntityName: PullRequest.entityName, in: managedObjectContext) {
        let pullRequestEntityModel = NSManagedObject(entity: pullRequestEntity, insertInto: managedObjectContext)
        
        pullRequestEntityModel.setValue(pullRequest.id, forKey: "id")
        pullRequestEntityModel.setValue(pullRequest.url, forKey: "url")
        pullRequestEntityModel.setValue(pullRequest.title, forKey: "title")
        pullRequestEntityModel.setValue(pullRequest.createdAt, forKey: "createdAt")
        pullRequestEntityModel.setValue(pullRequest.body, forKey: "body")
        pullRequestEntityModel.setValue(repo.id, forKey: "repoId")
        
        if let ownerEntity = NSEntityDescription.entity(forEntityName: Owner.entityName, in: managedObjectContext) {
          let ownerEntityModel = NSManagedObject(entity: ownerEntity, insertInto: managedObjectContext)
          
          ownerEntityModel.setValue(pullRequest.user?.id, forKey: "id")
          ownerEntityModel.setValue(pullRequest.user?.login, forKey: "login")
          ownerEntityModel.setValue(pullRequest.user?.avatarUrl, forKey: "avatarUrl")
          
          pullRequestEntityModel.setValue(ownerEntityModel, forKey: "user")
        }
      }
    }
    
    saveContext()
  }
  
  func fetchPullRequests (for repo: Repository) -> [PullRequest]? {
    let pullRequestsFetchRequest = NSFetchRequest<PullRequestEntity>(entityName: PullRequest.entityName)
    if let repoId = repo.id {
      let predicate = NSPredicate(format: "repoId = %@", "\(repoId)")
      
      pullRequestsFetchRequest.predicate = predicate
    } else {
      return nil
    }
    
    do {
      let pullRequestEntities = try managedObjectContext.fetch(pullRequestsFetchRequest)
      
      return pullRequestEntities.map{ pullRequestEntity -> PullRequest in
        var pullRequestJson: [String: Any] = [:]
        
        pullRequestJson["id"] = Int(pullRequestEntity.id)
        let idObj: [String: Any?] = ["id": Int(pullRequestEntity.repoId)]
        let repoObj: [String: Any?] = ["repo": idObj]
        pullRequestJson["base"] = repoObj
        
        if let url = pullRequestEntity.url {
          pullRequestJson["html_url"] = url
        }
        if let title = pullRequestEntity.title {
          pullRequestJson["title"] = title
        }
        if let createdAt = pullRequestEntity.createdAt {
          pullRequestJson["created_at"] = createdAt
        }
        if let body = pullRequestEntity.body {
          pullRequestJson["body"] = body
        }
        if let user = pullRequestEntity.user {
          var userJson: [String: Any?] = [:]
          
          userJson["id"] = Int(user.id)
          if let login = user.login {
            userJson["login"] = login
          }
          if let avatarUrl = user.avatarUrl {
            userJson["avatar_url"] = avatarUrl
          }
          
          pullRequestJson["user"] = userJson
        }
        
        return PullRequest(JSON: pullRequestJson)!
      }
    } catch let error as NSError {
      print("Error \(error.localizedDescription) with userinfo -> \(error.userInfo)")
    }
    return nil
  }
  
  private lazy var applicationDocumentsDirectory: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return urls[urls.count-1]
  }()
  
  private lazy var managedObjectModel: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(forResource: "GithubRepoFinder", withExtension: "momd")!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()
  
  lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
    let url = self.applicationDocumentsDirectory.appendingPathComponent("GithubRepoFinderCoreData.sqlite")
    
    do {
      try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
    } catch {
      let dict : [String : Any] = [
        NSLocalizedDescriptionKey: "Failed to initialize the application's saved data" as NSString,
        NSLocalizedFailureReasonErrorKey : "There was an error creating or loading the application's saved data." as NSString,
        NSUnderlyingErrorKey : error as NSError
      ]
      // Change the abort() into a useful error message
      let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
      print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
      abort()
    }
    
    return coordinator
  }()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    var managedObjectContext: NSManagedObjectContext?
    
    if #available(iOS 10.0, *){
      managedObjectContext = self.persistentContainer.viewContext
    } else{
      let coordinator = self.persistentStoreCoordinator
      managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
      managedObjectContext?.persistentStoreCoordinator = coordinator
    }
    
    return managedObjectContext!
  }()
  
  // iOS-10
  @available(iOS 10.0, *)
  lazy var persistentContainer: NSPersistentContainer = {
      /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
    let container = NSPersistentContainer(name: "GithubRepoFinder")
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
    print("\(self.applicationDocumentsDirectory)")
    return container
  }()
  
  // MARK: - Core Data Saving support
  
  func saveContext () {
    if managedObjectContext.hasChanges {
      do {
        try managedObjectContext.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
        abort()
      }
    }
  }
  
}
