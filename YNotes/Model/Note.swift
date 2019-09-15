//
//  Note.swift
//  YNotes
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Struct

struct Note {
    
    //MARK: • Property
    
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    let lastEditedDate: Date
    
    //MARK: - • Methods
    
    init(uid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = .white,
         importance: Importance,
         selfDestructionDate: Date? = nil,
         lastEditedDate: Date = Date())
    {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
        self.lastEditedDate = lastEditedDate
    }
    
    //MARK: - • Objects
    
    enum Importance: String, CaseIterable {
        case low
        case medium
        case high
    }
}

//MARK: - • Equatable
extension Note: Equatable {
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.uid == rhs.uid 
    }
    
}
