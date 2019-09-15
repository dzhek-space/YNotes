//
//  AuthInteractor.swift
//  YNotes
//
//  Created by Dzhek on 23/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol AuthInteractorProtocol: class {
    
    var presenter: AuthPresenterProtocol?  { get set }
    
    func fetchToken(for user: User) -> Bool
}


//MARK: - • Class

class AuthInteractor: AuthInteractorProtocol {
    
    //MARK: • Properties
    
    weak var presenter: AuthPresenterProtocol?
    
    private let commonQueue = OperationQueue()
    private var result: Bool?
    
    
    //MARK: - • Methods
    
    func fetchToken(for user: User) -> Bool {
        (Services.username, Services.password) = (user.username!, user.password!)
        let authOperation = AuthOperation(login: Services.username, password: Services.password)
        authOperation.completionBlock = {
            guard let operationResult = authOperation.result
                else {
                    logError("Authorization error ] -> [ request result: 'nil'")
                    return }
            
            self.result = operationResult
        }
        self.commonQueue.qualityOfService = .userInitiated
        self.commonQueue.addOperation(authOperation)
        
        while self.result  == nil {}

        print(print(#function), self.result!)
        return self.result!
    }
    
}
