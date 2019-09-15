//
//  NotesTableRouter.swift
//  YNotes
//
//  Created by Dzhek on 24/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Protocol

protocol NotesTableRouterProtocol {
    func presentEditNoteScene()
    func prepare(for segue: UIStoryboardSegue, note: Note?)
}

//MARK: - • Class

class NotesTableRouter: NotesTableRouterProtocol {
    
   //MARK: • Properties
    
    weak var notesTableVC: UITableViewController?
    
    private let mainQueue: OperationQueue = .main
    private let segueIdentifier = "NoteEditor"
    
    
    //MARK: - • Methods
    
    func presentEditNoteScene() {
        self.mainQueue.addOperation{
            self.notesTableVC?.performSegue(withIdentifier: self.segueIdentifier, sender: Any?.self)
        }
    }

    func prepare(for segue: UIStoryboardSegue, note: Note?) {
        if let editNoteVC = segue.destination as? EditorViewController {
            editNoteVC.configurator.configureModule(with: editNoteVC)
            let presenter = editNoteVC.presenter as! EditorViewInputProtocol
            if segue.identifier == self.segueIdentifier {
                presenter.receive(note: note)
            }
        }
    }
    
}
