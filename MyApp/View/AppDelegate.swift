//
//  AppDelegate.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

let networkIndicator = NetworkActivityIndicatorManager.shared

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  static let shared: AppDelegate = {
    guard let shared = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Cannot cast `UIApplication.shared.delegate` to `AppDelegate`.")
    }
    return shared
  }()
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    configNetwork()
    configTabarController()
    return true
  }
  private func configTabarController() {
    //create tabar controller
    //config tab Home
    let homeViewController = HomeViewController()
    let homeNavigationController = UINavigationController(rootViewController: homeViewController)
    homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image:  UIImage(named: "homeActive"), selectedImage: UIImage(named: "homeInActive"))
    
    //config tab Map
    let mapViewController = MapViewController()
    let mapNavigationController = UINavigationController(rootViewController: mapViewController)
    mapNavigationController.tabBarItem = UITabBarItem(title: "Map", image:  UIImage(named: "mapActive"), selectedImage: UIImage(named: "mapInActive"))
    
    //config tab Favorite
    let favoriteViewController = FavoriteViewController()
    let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
    favoriteNavigationController.tabBarItem = UITabBarItem(title: "Favorite", image:  UIImage(named: "favoriteActive"), selectedImage: UIImage(named: "favoriteInActive"))
    
    //config tab Profile
    let profileViewController = ProfileViewController()
    let profileNavigationController = UINavigationController(rootViewController: profileViewController)
    profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image:  UIImage(named: "profileActive"), selectedImage: UIImage(named: "profileInActive"))
    
    //add tabar item in tabarController
    let viewControllers = [homeNavigationController, mapNavigationController, favoriteNavigationController, profileNavigationController]
    let tabarController = UITabBarController()
    tabarController.viewControllers = viewControllers
    
    //config windows
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = tabarController
    window?.backgroundColor = .white
    window?.makeKeyAndVisible()
  }
}

extension AppDelegate {
  fileprivate func configNetwork() {
    networkIndicator.isEnabled = true
    networkIndicator.startDelay = 0
  }
}
