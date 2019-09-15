//
//  NotesTableState.swift
//  YNotes
//
//  Created by Dzhek on 30/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Objects

struct NotesTableInterfaceItem {
    let tableTitleOnLine: String = "Notes"
    let tableTitleOffLine: String = "Notes ~(offline)"
}

enum NotesTableMessage: String {
    case listNotesIsEmpty = "It looks like\n you have no notes\n tap +"
}

enum TypeTransition {
    case new
    case edited
}
