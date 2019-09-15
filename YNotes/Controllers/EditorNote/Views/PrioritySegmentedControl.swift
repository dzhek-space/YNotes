//
//  PrioritySegmentedControl.swift
//  YNotes
//
//  Created by Dzhek on 28/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

final class PrioritySegmentedControl: UISegmentedControl {
    
    //MARK: • Properties
    
    private let usedFontForSelected: UIFont = .boldSystemFont(ofSize: FontSize.title)
    private let usedFontForNormal: UIFont = .boldSystemFont(ofSize: FontSize.title)
    private let usedColorForSelected: UIColor = Palette.primary
    private let usedColorForNormal: UIColor = Palette.backgroundDark
    private let usedCornerRadius: CGFloat = Constants.cornerRadius
    private let usedBorderWidth: CGFloat = Constants.borderWidth
    private let usedInset: CGFloat = Constants.inset
    private let usedBackgroundColor: UIColor = Palette.white
    private let usedTintColor: UIColor = Palette.backgroundLight
    private let usedShadowRadius: CGFloat = 1
    private let usedShadowColor: CGColor = Palette.dark.cgColor
    private let usedShadowOffset: CGSize = CGSize(width: 0, height: 1)
    private let usedShadowOpacity: Float = 0.07

    
    //MARK: - • Methods
    
    func configure(with titles: [String]) {
        
        for index in 0 ..< titles.count {
            self.setTitle(titles[index], forSegmentAt: index)
        }
        self.setTitleTextAttributes([.font: self.usedFontForNormal,
                                     .foregroundColor: self.usedColorForNormal],
                                    for: .normal)
        self.setTitleTextAttributes([.font: self.usedFontForSelected,
                                     .foregroundColor: self.usedColorForSelected],
                                    for: .selected)
        
        self.selectedSegmentIndex = titles.count / 2
        
    }

    override func layoutSubviews() {
        self.tintColor = self.usedTintColor
        self.layer.frame.size.height = self.usedInset * 2.5
        self.backgroundColor = self.usedBackgroundColor
        self.layer.cornerRadius = self.usedCornerRadius
        self.layer.borderWidth = self.usedBorderWidth * 4
        self.layer.borderColor = Palette.white.cgColor
        self.layer.shadowOffset = self.usedShadowOffset
        self.layer.shadowColor = self.usedShadowColor
        self.layer.shadowRadius = self.usedShadowRadius
        self.layer.shadowOpacity = self.usedShadowOpacity
    
        super.layoutSubviews()
    }
}
