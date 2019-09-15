//
//  NoteConverter.swift
//  YNotes
//
//  Created by Dzhek on 29/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Struct

struct RawNote {
    
    //MARK: • Property
    
    let uid: String?
    let title: String
    let content: String
    let color: String
    let importance: String
    let selfDestructionDate: Date?
    let lastEditedDate: Date
    
    //MARK: - • Methods
    
    init(uid: String? = nil,
         title: String,
         content: String,
         color: String,
         importance: String,
         selfDestructionDate: Date? = nil,
         lastEditedDate: Date)
    {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
        self.lastEditedDate = lastEditedDate
    }
}


//MARK: - • Extension

extension RawNote {
    
    var converted: Note {
        let note = Note(uid: self.uid ?? UUID().uuidString,
                        title: self.title,
                        content: self.content,
                        color: UIColor(hex: self.color),
                        importance: Note.Importance(rawValue: self.importance) ?? .medium,
                        selfDestructionDate: self.selfDestructionDate,
                        lastEditedDate: self.lastEditedDate)
        return note
    }
    
}
