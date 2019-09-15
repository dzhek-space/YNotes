//
//  FileNotebookTests.swift
//  YNotesTests
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import XCTest
@testable import YNotes

class FileNotebookTests: XCTestCase {

    // MARK: - Property
    private var nbook: FileNotebook!
    private let noteOne = Note(title: "Note One", content: "Lorem ipsum dolor sit amet...", importance: .medium)
    private let noteTwo = Note(title: "Note Two", content: "Lorem ipsum dolor sit amet...", importance: .low)
    private let noteThree = Note(title: "Note Three", content: "Lorem ipsum dolor sit amet...", importance: .medium)
    
    // MARK: - Methods
    override func setUp() {
        super.setUp()
        nbook = FileNotebook()
    }
    
    override func tearDown() {
        nbook = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_Add_Delete() {
        
        XCTAssertTrue(nbook.notes.isEmpty)
        
        nbook.add(noteOne)
        XCTAssertTrue(nbook.notes.count == 1)
        
        nbook.add(noteTwo)
        XCTAssertTrue(nbook.notes.count == 2)
        
        nbook.add(noteThree)
        XCTAssertTrue(nbook.notes.count == 3)
        
        nbook.del(with: noteOne.uid)
        XCTAssertTrue(nbook.notes.count == 2)
        
        nbook.del(with: noteTwo.uid)
        nbook.del(with: noteThree.uid)
        XCTAssertTrue(nbook.notes.isEmpty)
    }
    
    func test_SaveToFile_LoadFromFile() {
        
        if nbook.notes.isEmpty {
            nbook.add(noteOne)
            nbook.add(noteTwo)
        } else { XCTFail(); return }
        
        nbook.saveToFile()
        nbook.del(with: noteOne.uid)
        nbook.del(with: noteTwo.uid)
        
        guard nbook.notes.isEmpty else { XCTFail(); return }
        
        nbook.loadFromFile()
        
        XCTAssertTrue(nbook.notes.count == 2)
        XCTAssertTrue(nbook.notes[noteOne.uid] != nil && nbook.notes[noteTwo.uid] != nil)
    }

}
