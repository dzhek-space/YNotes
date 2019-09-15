//
//  StyledButton.swift
//  YNotes
//
//  Created by Dzhek on 24/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

class StyledButton: UIButton {
    
    //MARK: • Properties
    
    private let usedCornerRadius: CGFloat = Constants.cornerRadius
    private let usedShadowRadius: CGFloat = 1
    private let usedShadowColor: CGColor = Palette.dark.cgColor
    private let usedShadowOffset: CGSize = CGSize(width: 0, height: 1)
    private let usedShadowOpacity: Float = 0.07
    private let usedBorderWidth = Constants.borderWidth
    
    
    //MARK: - • Methods
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .none
        self.layer.cornerRadius = self.usedCornerRadius
        self.layer.shadowOffset = self.usedShadowOffset
        self.layer.shadowColor = self.usedShadowColor
        self.layer.shadowRadius = self.usedShadowRadius
        self.layer.shadowOpacity = self.usedShadowOpacity
    }

    func setPrimaryStyle(color: UIColor = Palette.primary,
                         font: UIFont = UIFont.systemFont(ofSize: FontSize.title)) {
        self.setTitleColor(Palette.white, for: .normal)
        self.titleLabel?.font = font
        self.layer.backgroundColor = color.cgColor
    }
    
    func setSecondaryStyle(color: UIColor = Palette.primary,
                           font: UIFont = UIFont.systemFont(ofSize: FontSize.title)) {
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = self.usedBorderWidth
    }

}
