//
//  RemoveNoteDBOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation
import CoreData

//MARK: - • Class

class RemoveNoteDBOperation: BaseDBOperation {
    
    //MARK: • Properties
    
    var result: Bool? = false
    private let uid: String
    var backgroundContext: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<NoteBD>?
    
    
    //MARK: - • Methods
    
    init(uid: String, notebook: FileNotebook, modelName: String) {
        self.uid = uid
        super.init(notebook: notebook, modelName: modelName)
        self.backgroundContext = dataController.backgroundContext
    }
    
    override func main() {
        notebook.del(with: self.uid)
        
        self.fetchRequest = NoteBD.fetchRequest()
        
        if let fetchRequest = self.fetchRequest {
            fetchRequest.predicate = NSPredicate(format: "uid == %@", self.uid)
            self.backgroundContext.performAndWait {
                let noteDB = try? self.backgroundContext.fetch(fetchRequest).first
                guard let noteToDel = noteDB else {
                    logDebug("Note with uid = \"\(uid)\" not found in DB")
                    return
                }
                self.backgroundContext.delete(noteToDel)
                if self.backgroundContext.hasChanges {
                    do {
                        try self.backgroundContext.save()
                        self.result = true
                    } catch let error as NSError {
                        fatalError("Error: \(error.localizedDescription)\nCould not save Core Data context.")
                    }
                }
            }
        }
        finish()
    }
    
}
