//
//  AppDelegate.swift
//  MyApp
//
//  Created by iOSTeam on 2/21/18.
//  Copyright © 2018 Asian Tech Co., Ltd. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator
import CoreLocation

let networkIndicator = NetworkActivityIndicatorManager.shared

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  lazy var locationManager = CLLocationManager()
  typealias Action = (String?, (() -> Void)?)

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

}

extension AppDelegate {
  fileprivate func configNetwork() {
    networkIndicator.isEnabled = true
    networkIndicator.startDelay = 0
  }

  enum TitleTabarItem: String {
    case home
    case map
    case favorite
    case profile
  }

  enum ImageSelectedForTabar: String {
    case homeActive
    case mapActive
    case favoriteActive
    case profileActive
  }

  enum ImageDeSelectForTabar: String {
    case homeInActive
    case mapInActive
    case favoriteInActive
    case profileInActive
  }

  private func configTabarController() {
    //create tabar controller
    //config tab Home
    let homeViewController = HomeViewController()
    let homeNavigationController = UINavigationController(rootViewController: homeViewController)
    homeNavigationController.tabBarItem = UITabBarItem(
                                              title: TitleTabarItem.home.rawValue.capitalized,
                                              image: UIImage(named: ImageSelectedForTabar.homeActive.rawValue),
                                              selectedImage: UIImage(named: ImageDeSelectForTabar.homeInActive.rawValue))
    //config tab Map
    let mapViewController = MapViewController()
    let mapNavigationController = UINavigationController(rootViewController: mapViewController)
    mapNavigationController.tabBarItem = UITabBarItem(
                                              title: TitleTabarItem.map.rawValue.capitalized,
                                              image: UIImage(named: ImageSelectedForTabar.mapActive.rawValue),
                                              selectedImage: UIImage(named: ImageDeSelectForTabar.mapInActive.rawValue))
    //config tab Favorite
    let favoriteViewController = FavoriteViewController()
    let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)
    favoriteNavigationController.tabBarItem = UITabBarItem(
                                              title: TitleTabarItem.favorite.rawValue.capitalized,
                                              image: UIImage(named: ImageSelectedForTabar.favoriteActive.rawValue),
                                              selectedImage: UIImage(named: ImageDeSelectForTabar.favoriteInActive.rawValue))
    //config tab Profile
    let profileViewController = ProfileViewController()
    let profileNavigationController = UINavigationController(rootViewController: profileViewController)
    profileNavigationController.tabBarItem = UITabBarItem(
                                              title: TitleTabarItem.profile.rawValue.capitalized,
                                              image: UIImage(named: ImageSelectedForTabar.profileActive.rawValue),
                                              selectedImage: UIImage(named: ImageDeSelectForTabar.profileInActive.rawValue))
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

  func showAlert(title: String, message: String, actions: [Action]) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for action in actions {
      if let handler = action.1 {
        let alertAction = UIAlertAction(title: action.0, style: .default, handler: { (_) in
          handler()
        })
        alert.addAction(alertAction)
      } else {
        let alertAction = UIAlertAction(title: action.0, style: .default, handler: nil)
        alert.addAction(alertAction)
      }
    }
    window?.rootViewController?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - Location manager
extension AppDelegate {
  func configLocationService() {
    locationManager.delegate = self
    let status = CLLocationManager.authorizationStatus()
    switch status {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .authorizedWhenInUse, .authorizedAlways:
      enableLocationServices()
      startStandardLocationService()
    case .denied:
      let title = "Request location service"
      let message = "Please go to Setting > Privacy > Location service to turn on location service for \"Map Demo\""
      let action: Action = ("OK", nil)
      showAlert(title: title, message: message, actions: [action])
    case .restricted:
      break
    }
  }

  func enableLocationServices() {
    CLLocationManager.locationServicesEnabled()
  }

  // Standard location service
  func startStandardLocationService() {
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.distanceFilter = 50
    locationManager.startUpdatingLocation()
  }

  func stopStandardLocationService() {
    locationManager.stopUpdatingLocation()
  }
}

// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .restricted, .denied:
      stopStandardLocationService()
    case .authorizedWhenInUse, .authorizedAlways:
      enableLocationServices()
      startStandardLocationService()
    case .notDetermined:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let lastLocation = locations.last else { return }
    print("timestampe \(lastLocation.timestamp)")
    print("lat \(lastLocation.coordinate.latitude)")
    print("lng \(lastLocation.coordinate.longitude)")
  }
}
