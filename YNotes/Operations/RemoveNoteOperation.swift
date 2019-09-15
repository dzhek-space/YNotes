//
//  RemoveNoteOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Class

class RemoveNoteOperation: AsyncOperation {
    
    //MARK: • Properties
    
    private let removeNoteFromDB: RemoveNoteDBOperation
    private let dbQueue: OperationQueue
    private let isOnline: Bool
    private(set) var result: Bool? = false
    
    
    //MARK: - • Methods
    
    init(uid: String,
         notebook: FileNotebook,
         modelName: String,
         dbQueue: OperationQueue,
         backendQueue: OperationQueue,
         isOnline: Bool) {
        
        self.removeNoteFromDB = RemoveNoteDBOperation(uid: uid, notebook: notebook, modelName: modelName)
        self.dbQueue = dbQueue
        self.isOnline = isOnline
        super.init()
        
        self.removeNoteFromDB.completionBlock = {
            if self.isOnline {
                let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
                saveToBackend.completionBlock = {
                    switch saveToBackend.result! {
                    case .success:
                        self.result = true
                    case .failure:
                        self.result = false
                    }
                    self.finish()
                }
                backendQueue.addOperation(saveToBackend)
            }
            self.result = self.removeNoteFromDB.result
            self.finish()
        }
    }
    
    override func main() {
        self.dbQueue.addOperation(self.removeNoteFromDB)
    }
    
}
