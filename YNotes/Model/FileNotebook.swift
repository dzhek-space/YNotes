//
//  FileNotebook.swift
//  YNotes
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Class

class FileNotebook {
    
    //MARK: • Property
    
    private(set) var notes: [String: Note] = [:]
    
    private var checkDirectory: Bool {
        let cachesDirUrl = FileManager.default.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first!
        var isDir: ObjCBool = false
        let dirExists = FileManager.default.fileExists(atPath: cachesDirUrl.path,
                                                       isDirectory: &isDir)
        if dirExists, isDir.boolValue {
            return true
        } else {
            do {
                try FileManager.default.createDirectory(atPath: cachesDirUrl.path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
                return true
            } catch {
                logError("Error creating directory ] -> [ FUNC: \(#function) -- LINE: \(#line)")
                return false
            }
        }
    }
    
    private var checkFile: URL? {
        let fileName = "noteBook.json"
        let cachesDirUrl = FileManager.default.urls(for: .cachesDirectory,
                                                    in: .userDomainMask).first!
        let fileUrl = cachesDirUrl.appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: fileUrl.path)
            else { if FileManager.default.createFile(atPath: fileUrl.path,
                                                     contents: nil,
                                                     attributes: nil) {
                        return fileUrl
                    } else {
                        logError("Error creating file ] -> [ FUNC: \(#function) -- LINE: \(#line)")
                        return nil
                    }
        }
        return fileUrl
    }
    
    
    //MARK: - • Methods
    
    public func add(_ note: Note) {
        let thisIsCopy = !notes.filter{ $0.key == note.uid }.isEmpty
        if !thisIsCopy {
            notes[note.uid] = note
        } else {
            notes[note.uid] = note
        }
    }
    
    public func del(with uid: String) {
        notes[uid] = nil
    }
    
    public func saveToFile() {
        if checkDirectory, let path = checkFile {
            let jsonNotes = notes.map { _, note in note.json }
            do {
                let objData = try JSONSerialization.data(withJSONObject: jsonNotes, options: [])
                try objData.write(to: path)
            } catch {
                logError("Error saving data ] -> [ FUNC: \(#function) -- LINE: \(#line)")
            }
        }
    }
    
    public func loadFromFile(){
        if let path = checkFile {
            do {
                let loadedData = try Data(contentsOf: path)
                let objData = try JSONSerialization.jsonObject(with: loadedData, options: []) as! [Any]
                var counter = 0
                for item in objData {
                    if let obj = item as? [String: Any], let note = Note.parse(json: obj) {
                        notes[note.uid] = note
                        counter += 1
                    } else {
                        logError("Type conversion error ] -> [ FUNC: \(#function) -- LINE: \(#line)")
                    }
                }
            } catch {
                logError("Error loading data ] -> [ file not found ] -> [ FUNC: \(#function) -- LINE: \(#line)")
            }
        }
    }
    
}
