//
//  SaveNotesBackendOperation.swift
//  YNotes
//
//  Created by Dzhek on 31/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Class

class SaveNotesBackendOperation: BaseBackendOperation {
    
    //MARK: • Properties
    
    var result: SaveNotesBackendResult?
    private var endPoint = EndPoint()
    private var jsonNotes: String?

    //MARK: - • Methods
    
    init(notes: [String: Note]) {
        super.init()
        self.convertToStringType(notes: notes)
    }
    
    override func main() {
        let urlString: String
        let requectMethod: String
        if EndPoint.gistId.isEmpty {
            urlString = endPoint.baseURL + endPoint.notebook
            requectMethod = HTTPMethod.post.rawValue
        }
        else {
            urlString = endPoint.baseURL + endPoint.notebook + EndPoint.gistId
            requectMethod = HTTPMethod.patch.rawValue
        }
        guard let url = URL(string: urlString)
            else {
                NetworkError.message(funcName: "'Save_Notes_Backend_Operation.main()'", info: "Bad 'url'")
                self.result = .failure(.unreachable)
                return }
        guard let content = jsonNotes
            else {
                NetworkError.message(funcName: "'Save_Notes_Backend_Operation.main()'", info: "Bad 'json_Notes'")
                self.result = .failure(.unreachable)
                return }
        
        let file = File(content: content)
        let gist = Gist(description: "MyYnotes", files: ["ios-course-notes-db" : file])
        
        guard let data = try? newJSONEncoder().encode(gist)
            else {
                NetworkError.message(funcName: "'Save_Notes_Backend_Operation.main()'", info: "Bad data encode")
                self.result = .failure(.unreachable)
                return }
        
        self.result = self.send(data, to: url, method: requectMethod)
        while self.result == nil {}
        finish()
    }
    
    private func send(_ data: Data, to url: URL, method: String ) -> SaveNotesBackendResult? {
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("token \(Services.token)", forHTTPHeaderField: "Authorization")
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                logError("URLSession Error ] -> [ \(String(describing: self.result))")
                return
            }
            if let response = response as? HTTPURLResponse {
                let status = response.statusCode
                switch status {
                    case 200..<300:
                        self.result = .success
                        logDebug("Server response ] -> [ Successful: \(status)")
                    default:
                        self.result = .failure(.unreachable)
                        logError("Server response ] -> [ Error code: \(status)")
                }
                if status == 201 {
                    _ = response.allHeaderFields.filter({ key, value -> Bool in
                        if (key as! String) == "Location" {
                            let value = value as! String
                            let url = URL(string: value)
                            EndPoint.gistId = ("/" + url!.lastPathComponent)
                            print(EndPoint.gistId)
                            logDebug("File_Name: ios-course-notes-db ] -> [ Status: created")
                            return true
                        }
                        return false
                    })
                }
                if status == 200 {
                    logDebug("File_Name: ios-course-notes-db ] -> [ Status: edited")
                }
            }
        }.resume()
        
        return result
    }
    
    private func convertToStringType(notes: [String: Note]) {
        
        var prepareDict = [String: JSONote]()
        
        notes.forEach { (key, note) in
            let jsonNote = JSONote(uid: note.uid,
                                   title: note.title,
                                   content: note.content,
                                   color: note.color.hexValue,
                                   importance: note.importance.rawValue,
                                   selfDestructionDate: note.selfDestructionDate,
                                   lastEditedDate: note.lastEditedDate)
            prepareDict[key] = jsonNote
        }
        
        guard let data = try? newJSONEncoder().encode(prepareDict)
            else {
                NetworkError.message(funcName: #function, info: "Bad data encode"); return }
        
        if let jsonStr = String(bytes: data, encoding: .utf8) {
            self.jsonNotes = jsonStr
        } else {
            NetworkError.message(funcName: #function, info: "Bad 'json_Str'"); return }
        
    }
    
}
