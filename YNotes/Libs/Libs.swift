//
//  Libs.swift
//  YNotes
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation
import CocoaLumberjack

//MARK: - • Class

class Libs: NSObject {
    
    //MARK: • Property
    
    static let shared = Libs()
    
    //MARK: - • Methods
    
    func setup(with window: UIWindow? = nil) {
        let libs = Libs.shared
        libs.setupCocoaLumberjack()
    }
    
    private func setupCocoaLumberjack() {
        //        DDOSLogger.sharedInstance.logFormatter = CustomDDLogFormatter()
        //        DDLog.add(DDOSLogger.sharedInstance)
        
        DDTTYLogger.sharedInstance.logFormatter = CustomDDLogFormatter()
        DDLog.add(DDTTYLogger.sharedInstance)
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger, with: .all)
        
        //        debugPrint(fileLogger.logFileManager.sortedLogFilePaths.first ?? "URL fileLogger does't exist!")
    }
    
}
