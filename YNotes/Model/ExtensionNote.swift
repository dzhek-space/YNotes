//
//  ExtensionNote.swift
//  YNotes
//
//  Created by Dzhek on 07/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Extension

extension Note {
    
    //MARK: • Property
    
    var json: [String: Any] {
        
        var jsonObject = [String: Any]()
        
        jsonObject["uid"] = self.uid
        jsonObject["title"] = self.title
        jsonObject["content"] = self.content
        
        if self.color != .white && self.color != UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
            var (r,g,b,a) = (CGFloat(0),CGFloat(0),CGFloat(0),CGFloat(0))
            self.color.getRed(&r, green: &g, blue: &b, alpha: &a)
            let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            jsonObject["color"] = String(format:"%06x", rgb)
        }
        
        if self.importance != .medium {
            jsonObject["importance"] = self.importance.rawValue
        }
        
        if let dateIndicated = self.selfDestructionDate {
            jsonObject["selfDestructionDate"] = dateIndicated.timeIntervalSinceReferenceDate
        }
        
        jsonObject["lastEditedDate"] = lastEditedDate.timeIntervalSinceReferenceDate

        
        return jsonObject
    }
    
    
    //MARK: - • Methods
    
    static func parse(json: [String: Any]) -> Note? {
        
        guard
            let jsonUid = json["uid"] as? String,
            let jsonTitle = json["title"] as? String,
            let jsonContent = json["content"] as? String
        else  {
            logError("Json parsing Error ] -> [ 'uid', 'title' or 'content' not found")
            return nil
        }
        
        let jsonColor = json["color"] as? String
        let jsonImportance = json["importance"] as? String
        let jsonSelfDestructionDate = json["selfDestructionDate"] as? Double
        
        let color: UIColor
        if let colorString = jsonColor {
            let scanner = Scanner(string: colorString)
            var rgbValue:UInt32 = 0
            scanner.scanHexInt32(&rgbValue)
            let (r,g,b,a) = (CGFloat((rgbValue & 0xFF0000) >> 16),
                             CGFloat((rgbValue & 0x00FF00) >> 8),
                             CGFloat(rgbValue & 0x0000FF),
                             CGFloat(1.0))
            color = UIColor(red: r/255, green: g/255, blue: b/255,  alpha: a)
        } else {
            color = .white
        }
        
        let importance: Importance
        switch jsonImportance {
        case Note.Importance.high.rawValue: importance = .high
        case Note.Importance.low.rawValue: importance = .low
        default:  importance = .medium
        }
        
        let selfDestructionDate: Date?
        if let dateString = jsonSelfDestructionDate {
            selfDestructionDate = Date(timeIntervalSinceReferenceDate: dateString)
        } else {
            selfDestructionDate = nil
        }
        
        let lastEditedDate: Date
        if let jsonlastEditedDate = json["lastEditedDate"] as? Double {
            lastEditedDate = Date(timeIntervalSinceReferenceDate: jsonlastEditedDate)
        } else {
            logError("Json parsing Error ] -> [ 'lastEditedDate' is not defined, a new date is set")
            lastEditedDate = Date()
        }
        
        return Note(uid: jsonUid,
                    title: jsonTitle,
                    content: jsonContent,
                    color: color,
                    importance: importance,
                    selfDestructionDate: selfDestructionDate,
                    lastEditedDate: lastEditedDate)
    }
    
}
