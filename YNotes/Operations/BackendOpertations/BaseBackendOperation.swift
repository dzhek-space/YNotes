//
//  BaseBackendOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Objects

enum NetworkError: Error {
    case unreachable
    case badAuth
    
    static func message(funcName: String, info: String) {
        logError("func: \(funcName) ] [ Info: \(info)" )
    }
}

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

enum LoadNotesBackendResult {
    case success
    case failure(NetworkError)
}

enum AuthOperationResult {
    case success
    case failure(NetworkError)
}

//MARK: - • Class

class BaseBackendOperation: AsyncOperation {
    override init() {
        super.init()
    }
}
