//
//  EditorViewRouter.swift
//  YNotes
//
//  Created by Dzhek on 28/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Protocol

protocol EditorViewRouterProtocol {
    
    func popTableViewController()
    func presentColorPickerViewController(hexInitialColor: String)
    func prepareToPop(with note: Note, isNew: Bool)
}

//MARK: - • Class

class EditorViewRouter: EditorViewRouterProtocol {
    
    //MARK: • Properties
    
    weak var editorVC: UIViewController?
    private let mainQueue: OperationQueue = .main
    
    
    //MARK: - • Methods
    
    func popTableViewController() {
        self.mainQueue.addOperation {
            self.editorVC?.navigationController?.popViewController(animated: true)
        }
    }
    
    func prepareToPop(with note: Note, isNew: Bool) {
        let notesTableVC = editorVC?.parent?.children.first as? NotesTableViewInput
        let notesTablePresenter = notesTableVC?.presenter as! EditNoteOutputProtocol
        if  isNew {
            notesTablePresenter.saveNew(note)
        } else {
            notesTablePresenter.saveEdited(note)
        }
    }
    
    func presentColorPickerViewController(hexInitialColor: String) {
        let colorPickerVC = ColorPickerViewController()
        colorPickerVC.configurator.configureModule(with: colorPickerVC)
        let colorPickerPresenter = colorPickerVC.presenter
        colorPickerPresenter?.confirmColor(as: hexInitialColor)
        self.mainQueue.addOperation {
            self.editorVC?.navigationController?.pushViewController(colorPickerVC, animated: true)
        }
    }
    
}
