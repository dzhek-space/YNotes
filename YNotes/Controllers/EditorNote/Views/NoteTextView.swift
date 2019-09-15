//
//  NoteTextView.swift
//  NoteEditor
//
//  Created by Dzhek on 26/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

final class NoteTextView: UITextView {

    //MARK: • Properties
    
    private let usedFont: UIFont = .boldSystemFont(ofSize: FontSize.body)
    private let usedFontColor: UIColor = Palette.dark
    private let usedCornerRadius: CGFloat = Constants.cornerRadius
    private let usedInset: CGFloat = Constants.inset
    private let usedBackgroundColor: UIColor = Palette.white
    private let usedShadowRadius: CGFloat = 1
    private let usedShadowColor: CGColor = Palette.dark.cgColor
    private let usedShadowOffset: CGSize = CGSize(width: 0, height: 1)
    private let usedShadowOpacity: Float = 0.07

    
    //MARK: - • Methods
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.configure()
    }
    
    private func configure() {
        
        self.clipsToBounds = false
        self.backgroundColor = self.usedBackgroundColor
        self.layer.cornerRadius = self.usedCornerRadius
        self.textContainerInset = UIEdgeInsets(top: self.usedInset,
                                               left: self.usedInset / 2,
                                               bottom: self.usedInset,
                                               right: self.usedInset / 2)
        
        self.layer.shadowOffset = self.usedShadowOffset
        self.layer.shadowColor = self.usedShadowColor
        self.layer.shadowRadius = self.usedShadowRadius
        self.layer.shadowOpacity = self.usedShadowOpacity
        self.textColor = self.usedFontColor
        self.font = self.usedFont
    }
 

}
