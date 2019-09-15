//
//  AuthState.swift
//  YNotes
//
//  Created by Dzhek on 30/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Objects

typealias User = (username: String?, password: String?)

struct AuthInterfaceItem {
    let usernamePlaceholder = "Git username or email"
    let passwordPlaceholder = "Password"
    let singinButtonText = "Sing in"
    let offlineButtonText =  "Offline"
}

enum AuthErrorMessage: String {
    case authFailed = "Authorization failed"
    case emptyField = "Username & Password required"
}

