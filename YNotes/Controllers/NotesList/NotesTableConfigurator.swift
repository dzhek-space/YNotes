//
//  NotesTableConfigurator.swift
//  YNotes
//
//  Created by Dzhek on 24/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol NotesTableConfiguratorProtocol {
    func configureModule(with notesTableVC: NotesTableViewController)
}

//MARK: - • Class

final class NotesTableConfigurator: NotesTableConfiguratorProtocol {
    
    //MARK: • Methods
    
    func configureModule(with notesTableVC: NotesTableViewController) {
        let interactor = NotesTableInteractor()
        let router = NotesTableRouter()
        let notesTablePresenter = NotesTablePresenter(interface: notesTableVC,
                                                router: router,
                                                interactor: interactor)
        
        notesTableVC.presenter = notesTablePresenter
        interactor.presenter = notesTablePresenter
        router.notesTableVC = notesTableVC
    }
    
}
