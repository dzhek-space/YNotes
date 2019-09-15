//
//  AuthConfigurator.swift
//  YNotes
//
//  Created by Dzhek on 23/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol AuthConfiguratorProtocol {
    func configureModule(with authVC: AuthViewController)
}

 //MARK: - • Class

final class AuthConfigurator: AuthConfiguratorProtocol {
    
    //MARK: • Methods
    
    func configureModule(with authVC: AuthViewController) {
        let interactor = AuthInteractor()
        let router = AuthRouter()
        let presenter = AuthPresenter(interface: authVC,
                                          router: router,
                                          interactor: interactor)
        
        authVC.presenter = presenter
        interactor.presenter = presenter
        router.authVC = authVC
    }
    
}
