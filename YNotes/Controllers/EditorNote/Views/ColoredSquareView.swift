//
//  ColoredSquareStackview.swift
//  NoteEditor
//
//  Created by Dzhek on 26/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

final class ColoredSquareView: UIView {
    
    //MARK: • Properties
    
    private let usedCornerRadius: CGFloat = Constants.cornerRadius
    private let usedShadowRadius: CGFloat = 1
    private let usedShadowColor: CGColor = Palette.dark.cgColor
    private let usedShadowOffset: CGSize = CGSize(width: 0, height: 1)
    private let usedShadowOpacity: Float = 0.07
    
    private lazy var gradientLayer: CAGradientLayer = {
        
        let maskLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.usedCornerRadius)
        maskLayer.path = bezierPath.cgPath
        
        let rainbowLayer = CAGradientLayer()
        rainbowLayer.frame = self.bounds
        rainbowLayer.colors = [UIColor.red.cgColor,
                               UIColor.orange.cgColor,
                               UIColor.yellow.cgColor,
                               UIColor.green.cgColor,
                               UIColor.cyan.cgColor,
                               UIColor.blue.cgColor,
                               UIColor.purple.cgColor]
        
        rainbowLayer.locations = [0.0, 0.2, 0.4, 0.5, 0.6, 0.8, 1.0]
        rainbowLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        rainbowLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        let bwLayer = CAGradientLayer()
        bwLayer.frame = self.bounds
        bwLayer.colors = [UIColor(white: 0, alpha: 0.7).cgColor, UIColor.clear.cgColor]
        bwLayer.locations = [0.0, 1.0]
        bwLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        bwLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        bwLayer.compositingFilter = "hardLightBlendMode"
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.mask = maskLayer
        gradientLayer.addSublayer(rainbowLayer)
        gradientLayer.addSublayer(bwLayer)
        return gradientLayer
    }()
    
    
    //MARK: - • Methods
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .none
        self.layer.shadowOffset = self.usedShadowOffset
        self.layer.shadowColor = self.usedShadowColor
        self.layer.shadowRadius = self.usedShadowRadius
        self.layer.shadowOpacity = self.usedShadowOpacity
    }
    
    func colorize(backgroundColor: UIColor?) {
        
        let shapeLayer = CAShapeLayer()
        let bezierPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.usedCornerRadius)
        shapeLayer.path = bezierPath.cgPath
        
        if backgroundColor == nil { shapeLayer.addSublayer(gradientLayer) }
            else { shapeLayer.fillColor = backgroundColor!.cgColor }
        self.layer.addSublayer(shapeLayer)
    }
    
    
}

