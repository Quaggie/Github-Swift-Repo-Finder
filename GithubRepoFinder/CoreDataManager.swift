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