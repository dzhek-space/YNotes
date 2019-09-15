//
//  CheckView.swift
//  NoteEditor
//
//  Created by Dzhek on 26/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

final class CheckView: UIView {
    
    //MARK: • Methods
    
    override func draw(_ frame: CGRect) {

        let strokeColor = UIColor(red: 0.776, green: 0.000, blue: 0.000, alpha: 1.000)
        let fillColor = UIColor(red: 0.827, green: 0.000, blue: 0.000, alpha: 1.000)

        let combinedShapePath = UIBezierPath()
        combinedShapePath.move(to: CGPoint(x: 0.5, y: 6.99))
        combinedShapePath.addCurve(to: CGPoint(x: 6, y: 1),
                                   controlPoint1: CGPoint(x: 0.5, y: 3),
                                   controlPoint2: CGPoint(x: 3, y: 1))
        combinedShapePath.addCurve(to: CGPoint(x: 11.5, y: 6),
                                   controlPoint1: CGPoint(x: 8, y: 1),
                                   controlPoint2: CGPoint(x: 9.83, y: 2.67))
        combinedShapePath.addCurve(to: CGPoint(x: 17, y: 1),
                                   controlPoint1: CGPoint(x: 13.17, y: 2.67),
                                   controlPoint2: CGPoint(x: 15, y: 1))
        combinedShapePath.addCurve(to: CGPoint(x: 22.5, y: 6.99),
                                   controlPoint1: CGPoint(x: 20, y: 1),
                                   controlPoint2: CGPoint(x: 22.5, y: 3))
        combinedShapePath.addCurve(to: CGPoint(x: 11.5, y: 20.99),
                                   controlPoint1: CGPoint(x: 22.5, y: 9.65),
                                   controlPoint2: CGPoint(x: 18.83, y: 14.31))
        combinedShapePath.addCurve(to: CGPoint(x: 0.5, y: 6.99),
                                   controlPoint1: CGPoint(x: 4.17, y: 14.31),
                                   controlPoint2: CGPoint(x: 0.5, y: 9.65))
        combinedShapePath.close()
        combinedShapePath.move(to: CGPoint(x: 12.69, y: 17))
        combinedShapePath.addLine(to: CGPoint(x: 12.69, y: 13.47))
        combinedShapePath.addLine(to: CGPoint(x: 16, y: 7))
        combinedShapePath.addLine(to: CGPoint(x: 13.48, y: 7))
        combinedShapePath.addLine(to: CGPoint(x: 11.58, y: 11.11))
        combinedShapePath.addLine(to: CGPoint(x: 11.49, y: 11.11))
        combinedShapePath.addLine(to: CGPoint(x: 9.61, y: 7))
        combinedShapePath.addLine(to: CGPoint(x: 7, y: 7))
        combinedShapePath.addLine(to: CGPoint(x: 10.31, y: 13.53))
        combinedShapePath.addLine(to: CGPoint(x: 10.31, y: 17))
        combinedShapePath.addLine(to: CGPoint(x: 12.69, y: 17))
        combinedShapePath.close()
        combinedShapePath.usesEvenOddFillRule = true
        fillColor.setFill()
        combinedShapePath.fill()
        strokeColor.setStroke()
        combinedShapePath.lineWidth = 1
        combinedShapePath.miterLimit = 4
        combinedShapePath.stroke()

    }
    
    convenience init() {
        let checkFrame = CGRect(x: 25.0, y: -5.0, width: 24.0, height: 24.0)
        self.init(frame: checkFrame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
