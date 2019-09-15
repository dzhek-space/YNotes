//
//  NoteLabel.swift
//  YNotes
//
//  Created by Dzhek on 27/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

final class EditorSceneLabel: UILabel {
    
    //MARK: • Properties
    
    private let usedTileFont: UIFont = .boldSystemFont(ofSize: FontSize.title)
    private let usedBodyFont: UIFont = .systemFont(ofSize: FontSize.body)
    private let usedFontColor: UIColor = Palette.dark
    private let usedFontColorDangerStyle: UIColor = Palette.danger

    
    //MARK: - • Methods
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.configure()
    }

    private func configure() {
        self.font = self.usedTileFont
        self.textColor = self.usedFontColor
    }
    
    func configureDangerStyle() {
        self.textColor = self.usedFontColorDangerStyle
        self.font = self.usedBodyFont
    }
    
}
