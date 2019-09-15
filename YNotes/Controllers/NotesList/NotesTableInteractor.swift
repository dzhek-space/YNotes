//
//  NotesTableInteractor.swift
//  YNotes
//
//  Created by Dzhek on 24/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol NotesTableInteractorProtocol: class {
    
    var presenter: NotesTablePresenterProtocol?  { get set }
    var notebook: FileNotebook { get }
    var modelName: String { get }
    var resultOperation: Bool? { get }

    func loadData()
    func saveNote(_ note: Note, as type: TypeTransition)
    func isRemoved(_ note: Note) -> Bool
}


//MARK: - • Class

class NotesTableInteractor {
    
    //MARK: • Properties
    
    weak var presenter: NotesTablePresenterProtocol?
    
    let notebook = FileNotebook()
    let modelName: String = "YNotes"
    private let firstLoad: Bool = true
    var resultOperation: Bool?
    
    private let commonQueue = OperationQueue()
    private let dbQueue = OperationQueue()
    private let backendQueue = OperationQueue()
    
    private var load: AsyncOperation {
        let operation = LoadNotesOperation(notebook: self.notebook, modelName: self.modelName,
                                           dbQueue: self.dbQueue, backendQueue: self.backendQueue,
                                           isOnline: !self.presenter!.isOffline)
        operation.completionBlock = {
            if operation.result! {
                let notes = Array(self.notebook.notes.values)
                                            .sorted(by: { $0.lastEditedDate > $1.lastEditedDate })
                self.presenter?.notes = notes
                self.presenter?.isStartProcess = false
                self.presenter?.dataUploaded()

            } else {
                logError("Bad result of Load_Note_Operation")
                self.presenter?.isStartProcess = false
                self.presenter?.showResultOperation()
            }
        }
        return operation
    }
    
    init() {
        self.commonQueue.qualityOfService = .userInitiated
    }
    
    
    //MARK: - • Methods
    
    private func save(_ note: Note, isOnline: Bool, as type: TypeTransition) {
        let operation = SaveNoteOperation(note: note, notebook: self.notebook, modelName: self.modelName,
                                          dbQueue: self.dbQueue, backendQueue: self.backendQueue,
                                          isOnline: isOnline)
        operation.completionBlock = {
            self.presenter?.notes = Array(self.notebook.notes.values).sorted(by: { $0.lastEditedDate > $1.lastEditedDate })
            self.resultOperation = true
            switch self.presenter?.isStartProcess {
            case true:
                self.presenter?.isStartProcess = false
                self.presenter?.noteSaved(as: type)
            default:
                break
            }
        }
        self.commonQueue.addOperation(operation)
    }
    
    private func removeNote(with uid: String) -> Bool {
        var resultOperation: Bool?
        let operation = RemoveNoteOperation(uid: uid, notebook: self.notebook, modelName: self.modelName,
                                            dbQueue: self.dbQueue, backendQueue: self.backendQueue,
                                            isOnline: !self.presenter!.isOffline)
        operation.completionBlock = {
            if operation.result! {
                let notes = Array(self.notebook.notes.values).sorted(by: { $0.lastEditedDate > $1.lastEditedDate })
                self.presenter?.notes = notes
                resultOperation = true
            } else {
                logError("Bad result of Remove_Note_Operation")
                resultOperation = false
            }
            operation.finish()
        }
        self.commonQueue.addOperation(operation)
        
        while resultOperation == nil {}
        return resultOperation!
    }

}


//MARK: - • Protocol implementation

extension NotesTableInteractor: NotesTableInteractorProtocol {
    
 
    func loadData() {
        self.commonQueue.addOperation(load)
        self.commonQueue.addOperation {
            self.presenter?.isStartProcess = true
        }
    }
    
    func saveNote(_ note: Note, as type: TypeTransition) {
            self.save(note, isOnline: !self.presenter!.isOffline, as: type)
            self.presenter?.isStartProcess = true
    }
    
    func isRemoved(_ note: Note) -> Bool {
        let uid = note.uid
        let isRemoved = self.removeNote(with: uid)
        return isRemoved
    }
    
}
