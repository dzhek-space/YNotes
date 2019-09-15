//
//  StyledTextField.swift
//  YNotes
//
//  Created by Dzhek on 24/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

class StyledTextField: UITextField {
    
    private let usedFont: UIFont = .boldSystemFont(ofSize: FontSize.body)
    private let usedFontColor: UIColor = Palette.dark
    private let usedCornerRadius: CGFloat = Constants.cornerRadius
    private let usedInset: CGFloat = Constants.inset
    private let usedBackgroundColor: UIColor = Palette.white
    private let usedShadowRadius: CGFloat = 1
    private let usedShadowColor: CGColor = Palette.dark.cgColor
    private let usedShadowOffset: CGSize = CGSize(width: 0, height: 1)
    private let usedShadowOpacity: Float = 0.07
    private let usedBorderColor: UIColor = Palette.backgroundDark
    private let usedBorderWidth: CGFloat = Constants.borderWidth
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.configure()
    }
    
    private func configure() {
        self.borderStyle = .none
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.borderWidth = self.usedBorderWidth
        self.layer.borderColor = self.usedBorderColor.cgColor
        self.backgroundColor = self.usedBackgroundColor
        self.layer.cornerRadius = self.usedCornerRadius
        self.layer.shadowOffset = self.usedShadowOffset
        self.layer.shadowColor = self.usedShadowColor
        self.layer.shadowRadius = self.usedShadowRadius
        self.layer.shadowOpacity = self.usedShadowOpacity
        self.clearButtonMode = .whileEditing
        self.textColor = self.usedFontColor
        self.font = self.usedFont
    }
    

    let padding = UIEdgeInsets(top: Constants.inset / 2,
                               left: Constants.inset,
                               bottom: Constants.inset / 2,
                               right: Constants.inset)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

//    func setStyle(color: UIColor = Palette.dark,
//                   font: UIFont = UIFont.boldSystemFont(ofSize: FontSize.title),
//                   cornerRadius: CGFloat = Constants.cornerRadius,
//                   borderColor: UIColor? = Palette.backgroundDark,
//                   backgroundColor: UIColor = Palette.white,
//                   borderWidth: CGFloat? = Constants.borderWidth,
//                   returnKeyType: UIReturnKeyType = UIReturnKeyType.default ) {
//        
////        self.borderStyle = .none
////        self.backgroundColor = .clear
////        if let borderWidth = borderWidth { self.layer.borderWidth = borderWidth }
////        if let borderColor = borderColor { self.layer.borderColor = borderColor.cgColor }
////        self.layer.backgroundColor = backgroundColor.cgColor
////        self.layer.cornerRadius = cornerRadius
////        self.clipsToBounds = true
////        self.font = font
////        self.textColor = color
////        self.returnKeyType = returnKeyType
////        self.clearButtonMode = .whileEditing
//    }
    
    func clear() {
        self.text = ""
    }
    
}
