//
//  EditorState.swift
//  YNotes
//
//  Created by Dzhek on 30/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Objects

typealias Priorities = Note.Importance

struct EditorInterfaceItem {
    
    let titleNoteLabelText: String = "Note name"
    let contentNoteLabelText: String = "Note text"
    let switchLabelText: String = "Use Destroy Date"
    let descriptionDateLabelText: String = "Date of destruction"
    let defaultDestructionDateLabelText: String = "not set"
    let datePickerButtonDisableTitle: String = "Choose a future date"
    let datePickerButtonNormalTitle: String = "Set Date"
    let colorSetLabelText: String = "Note color"
    let priorityLabelText: String = "Note Priority"
    let notePriorities: [String] = ["low", "medium", "high"]
//    let stateSaveButton: Bool = false
    
    func titleVC(_ state:Bool) -> String {
        let title = state ? "Edit Note" : "New Note"
        return title
    }
}
