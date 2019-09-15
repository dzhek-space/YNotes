//
//  NoteTableViewCell.swift
//  YNotes
//
//  Created by Dzhek on 19/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var colorOfNoteView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var colorLabelView: UIView!
    
    func configureStyle() {
        self.titleLabel.setTitleStyle()
        self.contentLabel.setContentStyle()
        self.date.setDangerStyle()
        self.colorLabelView.layer.cornerRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
