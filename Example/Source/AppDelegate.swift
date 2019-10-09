//
//  AppDelegate.swift
//  Example
//
//  Created by Vadim Morozov on 1/26/18.
//  Copyright © 2018 Touchlane LLC. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let rootVC = ViewController()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        return true
    }
}
