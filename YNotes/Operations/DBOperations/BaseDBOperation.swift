//
//  BaseDBOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Class

class BaseDBOperation: AsyncOperation {
    
    //MARK: • Properties
    
    let notebook: FileNotebook
    let dataController: DataController
    
    //MARK: - • Methods
    
    init(notebook: FileNotebook, modelName: String) {
        self.notebook = notebook
        self.dataController = DataController(modelName: modelName)
        super.init()
    }
    
}
