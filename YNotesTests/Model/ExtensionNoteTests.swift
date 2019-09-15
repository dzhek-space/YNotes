//
//  ExtensionNoteTests.swift
//  YNotesTests
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import XCTest
@testable import YNotes

class ExtensionNoteTests: XCTestCase {
    
    // MARK: - Property
    private var sutFull, sutShort: Note!
    private let uidTest: String = "xxx"
    private let titleTest: String = "Title"
    private let contentTest: String = "Lorem ipsum dolor sit amet..."
    private let colorTest: UIColor = .cyan
    private let importanceTest: Note.Importance = .high
    private let importanceShortTest: Note.Importance = .medium
    private let dateTest: Date = .init()
    
    // MARK: - Methods
    override func setUp() {
        super.setUp()
        sutFull = Note(uid: uidTest,
                       title: titleTest,
                       content: contentTest,
                       color: colorTest,
                       importance: importanceTest,
                       selfDestructionDate: dateTest)
        
        sutShort = Note(title: titleTest,
                        content: contentTest,
                        importance: importanceShortTest)
    }
    
    override func tearDown() {
        
        sutFull = nil
        sutShort = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func test_JsonAndViceVersa_ForFullInstance() {
        let fullJson = sutFull.json
        let copySutFull = Note.parse(json: fullJson)!
        
        XCTAssertEqual(sutFull.uid, copySutFull.uid)
        XCTAssertEqual(sutFull.title, copySutFull.title)
        XCTAssertEqual(sutFull.content, copySutFull.content)
        XCTAssertEqual(sutFull.color, copySutFull.color)
        XCTAssertEqual(sutFull.importance, copySutFull.importance)
        XCTAssertEqual(sutFull.selfDestructionDate, copySutFull.selfDestructionDate)
    }
    
    func test_JsonAndViceVersa_ForShortInstance() {
        let shortJson = sutShort.json
        let copySutShort = Note.parse(json: shortJson)!
        
        XCTAssertEqual(sutShort.uid, copySutShort.uid)
        XCTAssertEqual(sutShort.title, copySutShort.title)
        XCTAssertEqual(sutShort.content, copySutShort.content)
        XCTAssertEqual(sutShort.color, copySutShort.color)
        XCTAssertEqual(sutShort.importance, copySutShort.importance)
        XCTAssertEqual(sutShort.selfDestructionDate, copySutShort.selfDestructionDate)
    }

}
