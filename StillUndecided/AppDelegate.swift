//
//  AppDelegate.swift
//  StillUndecided
//
//  Created by 16 on 07/12/2017.
//  Copyright © 2017 Style RU Unofficial fan club. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
        return true
    }
}


extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}


