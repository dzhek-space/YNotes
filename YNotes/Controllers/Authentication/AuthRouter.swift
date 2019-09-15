//
//  AuthRouter.swift
//  YNotes
//
//  Created by Dzhek on 23/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Protocol

protocol AuthRouterProtocol {
//    var presenter: AuthPresenterRouterProtocol? { get }
    func presentNotesList()
    func prepare(for segue: UIStoryboardSegue, stateSessoin: Bool)
}

//MARK: - • Class

class AuthRouter: AuthRouterProtocol {
    
    //MARK: • Properties
    
    weak var authVC: UIViewController?
//    weak var presenter: AuthPresenterRouterProtocol?
    
    private let mainQueue: OperationQueue = .main
    private let segueIdentifier = "NoteList"
    
    
    //MARK: - • Methods
    
    func presentNotesList() {
        self.mainQueue.addOperation{
            self.authVC?.performSegue(withIdentifier: self.segueIdentifier, sender: Any?.self)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, stateSessoin: Bool) {
        if let tabBarController = segue.destination as? UITabBarController,
            let navigationVC = tabBarController.children.first as? UINavigationController,
            let notesTableVC = navigationVC.topViewController as? NotesTableViewController {
            notesTableVC.configurator.configureModule(with: notesTableVC)
            let presenter = notesTableVC.presenter as! AuthOutputProtocol
            presenter.setMode(as: stateSessoin)
        }
    }
    
}

//AuthOutputProtocol
