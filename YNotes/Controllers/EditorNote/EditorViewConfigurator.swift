//
//  EditorViewConfigurator.swift
//  YNotes
//
//  Created by Dzhek on 28/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol EditorViewConfiguratorProtocol {
    func configureModule(with editorVC: EditorViewController)
}

//MARK: - • Class

final class EditorViewConfigurator: EditorViewConfiguratorProtocol {
    
    //MARK: • Methods
    
    func configureModule(with editorVC: EditorViewController) {
        let router = EditorViewRouter()
        let presenter = EditorViewPresenter(interface: editorVC, router: router)
        
        editorVC.presenter = presenter
        router.editorVC = editorVC
    }
    
}
