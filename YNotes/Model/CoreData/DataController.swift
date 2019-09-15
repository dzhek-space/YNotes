//
//  DataController.swift
//  YNotes
//
//  Created by Dzhek on 17/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation
import CoreData

//MARK: - • Class

final class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    init(modelName: String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
        
        self.load()
    }
    
    func load(completion: (()->Void)? = nil) {
        self.persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
        
        completion?()
    }
    
}

//MARK: - • Extension

extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
}
