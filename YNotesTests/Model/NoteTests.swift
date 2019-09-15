//
//  YNotesTests.swift
//  YNotesTests
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import XCTest
@testable import YNotes

class NoteTests: XCTestCase {
    
    // MARK: - Property
    private var sut: Note!
    private let uidTest: String = "xxx"
    private let titleTest: String = "Title"
    private let contentTest: String = "Lorem ipsum dolor sit amet..."
    private let colorTest: UIColor = .cyan
    private let importanceTest: Note.Importance = .high
    private let dateTest: Date = .init()
    
    // MARK: - Methods
    override func setUp() {
        super.setUp()
        sut = Note(uid: uidTest,
                   title: titleTest,
                   content: contentTest,
                   color: colorTest,
                   importance: importanceTest,
                   selfDestructionDate: dateTest)
    }
    
    override func tearDown() {
        
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_FullInitNote() {
        let noteTest = Note(uid: uidTest,
                            title: titleTest,
                            content: contentTest,
                            color: colorTest,
                            importance: importanceTest,
                            selfDestructionDate: dateTest)
        
        XCTAssertNotNil(noteTest)
        
        XCTAssertEqual(sut.uid, noteTest.uid)
        XCTAssertEqual(sut.title, noteTest.title)
        XCTAssertEqual(sut.content, noteTest.content)
        XCTAssertEqual(sut.color, noteTest.color)
        XCTAssertEqual(sut.importance, noteTest.importance)
        XCTAssertEqual(sut.selfDestructionDate, noteTest.selfDestructionDate)
    }
    
    func test_ShortInitNote() {
        let noteTest = Note(title: titleTest,
                            content: contentTest,
                            importance: importanceTest)
        
        XCTAssertNotNil(noteTest)
        
        XCTAssertEqual(sut.title, noteTest.title)
        XCTAssertEqual(sut.importance, noteTest.importance)
        XCTAssertEqual(sut.content, noteTest.content)
        
        XCTAssertNotEqual(sut.uid, noteTest.uid)
        XCTAssertNotEqual(sut.color, noteTest.color)
        XCTAssertNotEqual(sut.selfDestructionDate, noteTest.selfDestructionDate)
    }
    
    func test_ShortInitNote_DefaultProperties() {
        let noteTest = Note(title: titleTest,
                            content: contentTest,
                            importance: importanceTest)
        
        XCTAssertEqual(noteTest.color, .white)
        XCTAssertEqual(noteTest.selfDestructionDate, nil)
    }
    
}
