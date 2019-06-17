//
//  AppDelegate.swift
//  Bitcoin Converter
//
//  Created by Dosbol Duysekov on 6/11/19.
//  Copyright © 2019 Dosbol Duysekov. All rights reserved.
//

import UIKit

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = HomeTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}

