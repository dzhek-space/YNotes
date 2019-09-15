//
//  ExtUIDate.swift
//  YNotes
//
//  Created by Dzhek on 19/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

extension Date {
    
    func asString(format: String = "d MMM, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
