//
//  AppDelegate.swift
//  WebView_Approach
//
//  Created by Adam Essam on 03/12/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           // Initialize the window
           window = UIWindow(frame: UIScreen.main.bounds)

           // Setup the coordinator with the navigation controller
           let navigationController = UINavigationController()
           let coordinator = WebCoordinator(navigationController: navigationController)
           coordinator.start()

           // Set the root view controller and make the window visible
           window?.rootViewController = navigationController
           window?.makeKeyAndVisible()

           return true
       }

}

