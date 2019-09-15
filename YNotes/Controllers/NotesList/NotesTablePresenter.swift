//
//  NotesTablePresenter.swift
//  YNotes
//
//  Created by Dzhek on 20/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol NotesTablePresenterProtocol: class {
    
    var router: NotesTableRouterProtocol { get }
    var notes: [Note] { get set }
    var isOffline: Bool { get set }
    var isStartProcess: Bool { get set }
    
    func configureView()
    func dataUploaded()
    func addNewNote()
    func saveEdited(_ note: Note)
    func noteSaved(as type: TypeTransition)
    func showResultOperation()
    
    func saveNew(_ note: Note)
    func remove(_ note: Note)
}

protocol AuthOutputProtocol: class {
     func setMode(as stateSessoin: Bool)
}

protocol EditNoteOutputProtocol: class {
    
    func saveEdited(_ note: Note)
    func saveNew(_ note: Note)
}

//MARK: - • Class

class NotesTablePresenter {
    
    //MARK: • Properties
    
    weak var notesTableVC: NotesTableViewProtocol?
    let router: NotesTableRouterProtocol
    private let interactor: NotesTableInteractorProtocol
    
    var notes: [Note] = []
    var isOffline: Bool = false
    var isStartProcess: Bool = false
    let interfaceItem = NotesTableInterfaceItem()
    
    //MARK: - • Methods
    
    init(interface: NotesTableViewProtocol,
         router: NotesTableRouterProtocol,
         interactor: NotesTableInteractorProtocol) {
        
        self.notesTableVC = interface
        self.router = router
        self.interactor = interactor
    }
    
}


//MARK: - • Protocols implementation

extension NotesTablePresenter: NotesTablePresenterProtocol {

    func configureView() {
        self.notesTableVC?.setupViews()
        let tableTitle = isOffline ? interfaceItem.tableTitleOffLine : interfaceItem.tableTitleOnLine
        self.notesTableVC?.setupTableTitle(as: tableTitle)
        self.notesTableVC?.togleStateLeftBarButtonItem()
        
        if !self.isStartProcess {
            self.notesTableVC?.showLoader()
            self.interactor.loadData()
        }
        
    }
    
    func dataUploaded() {
        self.notesTableVC?.updateViews()
        self.notesTableVC?.togleStateLeftBarButtonItem()
    }
    
    func addNewNote() {
        self.router.presentEditNoteScene()
    }
    
    func remove(_ note: Note) {
        if self.interactor.isRemoved(note) {
            self.notesTableVC?.makeDelete()
            if self.notes.isEmpty {
                self.notesTableVC?.showMessage(.listNotesIsEmpty)
            }
            self.notesTableVC?.togleStateLeftBarButtonItem()
        }
    }
}


extension NotesTablePresenter: AuthOutputProtocol {
    func setMode(as stateSessoin: Bool) {
        self.isOffline = stateSessoin
    }
}


extension NotesTablePresenter: EditNoteOutputProtocol {
    
    func saveEdited(_ note: Note) {
        if !self.isStartProcess {
           self.interactor.saveNote(note, as: .edited)
        }
    }
    
    func saveNew(_ note: Note) {
        if !self.isStartProcess {
            self.interactor.saveNote(note, as: .new)
        }
    }
    
    func noteSaved(as type: TypeTransition) {
        if !self.isStartProcess {
                self.notesTableVC?.hideLoader()
            switch type {
            case .new:
                if !self.notes.isEmpty {
                    self.notesTableVC?.hideMessage()
                }
                self.notesTableVC?.insertRow()

            case .edited:
                self.notesTableVC?.makeCellTransition()
            }
            self.notesTableVC?.togleStateLeftBarButtonItem()
        }
        
    }
    
    func showResultOperation() {
        self.notesTableVC?.showMessage(.listNotesIsEmpty)
    }
    
}
