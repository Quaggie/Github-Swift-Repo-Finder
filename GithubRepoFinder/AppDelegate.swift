//
//  AppDelegate.swift
//  GithubRepoFinder
//
//  Created by Jonathan Bijos on 19/01/17.
//  Copyright © 2017 Quaggie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Carregando as informações assim que o app inicia
    GithubAPI.shared.loadRepos()
    return true
  }

  func applicationWillTerminate(_ application: UIApplication) {
    CoreDataManager.shared.saveContext()
  }
}

