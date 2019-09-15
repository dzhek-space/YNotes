//
//  LoadNoteDBOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit
import CoreData

//MARK: - • Class

class LoadNotesDBOperation: BaseDBOperation {
    
    //MARK: • Properties
    
    var result: Bool? = false
    var backgroundContext: NSManagedObjectContext!
    var fetchRequest: NSFetchRequest<NoteBD>?
    
    //MARK: - • Methods
    
    override init(notebook: FileNotebook, modelName: String) {
        super.init(notebook: notebook, modelName: modelName)
        self.backgroundContext = dataController.backgroundContext
    }

    override func main() {
        self.fetchRequest = NoteBD.fetchRequest()
        if let fetchRequest = self.fetchRequest {
            
            backgroundContext.performAndWait {
                do {
                    let notesDB = try fetchRequest.execute()
                    guard !notesDB.isEmpty else { return }
                    notesDB.forEach { noteDB in
                        let note = Note(uid: noteDB.uid!,
                                        title: noteDB.title!,
                                        content: noteDB.content!,
                                        color: UIColor(hex: "\(noteDB.color!)"),
                                        importance: Note.Importance(rawValue: noteDB.importance!)!,
                                        selfDestructionDate: noteDB.selfDestructionDate,
                                        lastEditedDate: noteDB.lastEditedDate!)
                        self.notebook.add(note)
                    }
                    self.result = true
                    
                } catch let error as NSError {
                    fatalError("Error: \(error.localizedDescription)")
                }
            }

        }
        print("DB LoadNotesOperation -> \(String(describing: self.result!))")
        finish()
    }
    
}
