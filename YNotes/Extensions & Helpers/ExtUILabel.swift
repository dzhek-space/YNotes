//
//  ExtUILabel.swift
//  HelloUser_4_1
//
//  Created by Dzhek on 15/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setStyle(font: UIFont = UIFont.boldSystemFont(ofSize: FontSize.body),
                  lines: Int = 0) {
        self.textColor = Palette.dark
        self.font = font
        self.numberOfLines = lines
    }
    
    func setTitleStyle(font: UIFont = UIFont.boldSystemFont(ofSize: FontSize.title),
                       lines: Int = 2) {
        self.textColor = Palette.dark
        self.font = font
        self.numberOfLines = lines
    }
    
    func setContentStyle(font: UIFont = UIFont.systemFont(ofSize: FontSize.body),
                         lines: Int = 5) {
        self.textColor = Palette.dark
        self.font = font
        self.numberOfLines = lines
    }
    
    func setInfoStyle(font: UIFont = UIFont.boldSystemFont(ofSize: FontSize.subtitle),
                      lines: Int = 1) {
        self.textColor = Palette.gray
        self.font = font
        self.numberOfLines = lines
    }
    
    func setDangerStyle(font: UIFont = UIFont.boldSystemFont(ofSize: FontSize.notation),
                             lines: Int = 1) {
        self.textColor = Palette.danger
        self.font = font
        self.numberOfLines = lines
    }
    
    func setStyledTitle(_ string: String) -> UILabel {
        let arrayString = string.split{ $0 == "~" }.map{ String($0) }
        var attributedString = NSMutableAttributedString()
        let primaryAttribute: [NSAttributedString.Key: Any] = [.foregroundColor : Palette.dark,
                                                               .font : UIFont.boldSystemFont(ofSize: FontSize.title)]
        let secondaryAttribute: [NSAttributedString.Key: Any] = [.foregroundColor : Palette.gray,
                                                                 .font : UIFont.boldSystemFont(ofSize: FontSize.subtitle)]
        if arrayString.count > 1 {
            attributedString = NSMutableAttributedString(string: arrayString.first!, attributes: primaryAttribute)
            let restWords = " " + arrayString[1...].joined(separator: " ")
            let attributedRestWords = NSMutableAttributedString(string: restWords, attributes: secondaryAttribute)
            attributedString.append(attributedRestWords)
        } else {
            attributedString = NSMutableAttributedString(string: string, attributes: primaryAttribute)
        }
        self.attributedText = attributedString
        return self
    }
}
