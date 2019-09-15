//
//  LoadNotesBackendOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation
import UIKit

//MARK: - • Class

class LoadNotesBackendOperation: BaseBackendOperation {
    
    //MARK: • Properties
    
    var result: LoadNotesBackendResult?
    let notebook: FileNotebook?
    private var endPoint = EndPoint()
    
    
    //MARK: - • Methods
    
    init(notebook: FileNotebook) {
        self.notebook = notebook
        super.init()
    }
    
    override func main() {
        
        let urlString: String
        let method: String
        if !EndPoint.gistId.isEmpty {
            urlString = endPoint.baseURL + endPoint.notebook + EndPoint.gistId
            method = HTTPMethod.get.rawValue
            guard let url = URL(string: urlString)
                else {
                    NetworkError.message(funcName: "'Load_Notes_Backend_Operation.main()'", info: "Bad 'url'")
                    self.result = .failure(.unreachable)
                    finish()
                    return
            }
            
            self.result = self.fetch(from: url, method: method)
            
        } else {
            NetworkError.message(funcName: "'Load_Notes_Backend_Operation.main()'", info: "Bad 'gist_Id'")
            self.result = .failure(.unreachable)
        }
        
        while self.result == nil {}
        print("BACKEND LoadNotesOperation -> \(self.result!)")
        finish()
    }
    
    private func fetch(from url: URL, method: String ) -> LoadNotesBackendResult? {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("token \(Services.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let response = response as? HTTPURLResponse {
                let status = response.statusCode
                switch status {
                case 200..<300:
                    logDebug("Server response ] -> [ Successful: \(status)")
                default:
                    self.result = .failure(.unreachable)
                    logError("Fetch operation failed ] -> [ Server response: \(status)")
                }
            }
            guard let data = data
                else {
                    NetworkError.message(funcName: "fetch", info: "Bad Data")
                    self.result = .failure(.unreachable)
                    return }
            do {
                let gists = try newJSONDecoder().decode(Gist.self, from: data)
                let jsonStr = gists.files[Services.fileName]!.content
                let result = self.convertToNoteType(content: jsonStr)
                self.result = result ? .success : .failure(.unreachable)
            } catch {
                self.result = .failure(.unreachable)
                NetworkError.message(funcName: "fetch", info: "Bad decoding")
            }
        }.resume()
        return self.result
    }
    
    private func convertToNoteType(content: String) -> Bool {
        let data = content.data(using: .utf8)!
        guard let jsonNotes = try? newJSONDecoder().decode([String:JSONote].self, from: data)
            else {
                NetworkError.message(funcName: #function, info: "Bad json_Notes dencode")
                self.result = .failure(.unreachable)
                return false}
        var notes = [String:Note]()
        jsonNotes.values.forEach { jsonNote in
            let note = Note(uid: jsonNote.uid,
                            title: jsonNote.title,
                            content: jsonNote.content,
                            color: UIColor(hex: "\(jsonNote.color)"),
                            importance: Note.Importance(rawValue: jsonNote.importance)!,
                            selfDestructionDate: jsonNote.selfDestructionDate,
                            lastEditedDate: jsonNote.lastEditedDate)
            
            notes[note.uid] = note
        }
        
        guard let notebook = self.notebook else { return false }
        notes.forEach { (_, value) in
            notebook.add(value)
        }
        return true
    }
}
