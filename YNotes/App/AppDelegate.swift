//
//  AppDelegate.swift
//  YNotes
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK: - External Library Initialization
        let libs = Libs.shared
        libs.setup(with: window)
        
        
        #if LITE_VERSION
            logDebug("RUNNING LITE_VERSION APP")
            #else
            logDebug("RUNNING FULL_VERSION APP")
            #endif

        return true
    }
    
}

