//
//  LoadNoteOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Class

class LoadNotesOperation: AsyncOperation {
    
    //MARK: • Properties
    
    private let loadFromDB: LoadNotesDBOperation
    private let loadFromBackend: LoadNotesBackendOperation
    private let dbQueue: OperationQueue
    private let backendQueue: OperationQueue
    private let notebook: FileNotebook
    private var isNotebookUpdateNeeded: Bool = false
    private(set) var result: Bool? = false
    private let isOnline: Bool
    
    
    //MARK: - • Methods
    
    init(notebook: FileNotebook,
         modelName: String,
         dbQueue: OperationQueue,
         backendQueue: OperationQueue,
         isOnline: Bool) {
        
        self.notebook = notebook
        self.isOnline = isOnline
        
        self.loadFromDB = LoadNotesDBOperation(notebook: notebook, modelName: modelName)
        self.dbQueue = dbQueue
        
        self.loadFromBackend = LoadNotesBackendOperation(notebook: notebook)
        self.backendQueue = backendQueue
        
        super.init()
        
        if self.isOnline {
            self.addDependency(self.loadFromBackend)
            self.backendQueue.addOperation(self.loadFromBackend)
        }
        
        
        self.loadFromDB.completionBlock =  {
            let resultDB = self.loadFromDB.result!
            if self.isOnline {
                let resultBackEnd: Bool
                switch self.loadFromBackend.result! {
                case .success:
                    resultBackEnd = true
                case .failure:
                    resultBackEnd = false
                }
                
                if resultDB && resultBackEnd {
                    self.result = true
                }
            } else {
                self.result = resultDB
            }
            self.finish()
        }
    }
    
    override func main() {
        self.dbQueue.addOperation(self.loadFromDB)
    }
    
}

