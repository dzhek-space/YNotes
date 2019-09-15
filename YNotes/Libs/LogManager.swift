//
//  LogManager.swift
//  YNotes
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation
import CocoaLumberjack

//MARK: - • Public Logging Methods

public func logError(_ message: @autoclosure () -> String) {
    DDLogError(message())
}
public func logWarn(_ message: @autoclosure () -> String) {
    DDLogWarn(message())
}
public func logInfo(_ message: @autoclosure () -> String) {
    DDLogInfo(message())
}
public func logDebug(_ message: @autoclosure () -> String) {
    DDLogDebug(message())
}
public func logVerbose(_ message: @autoclosure () -> String) {
    DDLogVerbose(message())
}

//MARK: - • Public Logging Objects

public class CustomDDLogFormatter: NSObject, DDLogFormatter {
    
    //MARK: • Property
    
    let dateFormmater = DateFormatter()
    
    //MARK: - • Methods
    
    public override init() {
        super.init()
        dateFormmater.dateFormat = "yyyy/MM/dd HH:mm:ss:SSS"
    }
    
    public func format(message logMessage: DDLogMessage) -> String? {
        
        let logLevel: String
        
        switch logMessage.flag {
        case DDLogFlag.error: logLevel = "  ERROR  "
        case DDLogFlag.warning: logLevel = " WARNING "
        case DDLogFlag.info: logLevel = "  INFO   "
        case DDLogFlag.debug: logLevel = "  DEBUG  "
        default: logLevel = " VERBOSE "
        }
        
        let dateLog = dateFormmater.string(from: logMessage.timestamp)
        let logMsg = logMessage.message.uppercased()
        let threadId = logMessage.threadID
        
        return "\(dateLog) [\(threadId)] [\(logLevel)] -> [ \(logMsg) ]"
    }
}
