//
//  UIViewController.swift
//  HelloUser_4_1
//
//  Created by Dzhek on 15/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController) {
        self.addChild(child)
        DispatchQueue.main.async() { [weak self] in
            self?.view.addSubview(child.view)
            child.didMove(toParent: self)
        }
    }
    
    func remove() {
        guard self.parent != nil else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
            self?.willMove(toParent: nil)
            self?.view.removeFromSuperview()
            self?.removeFromParent()
        }
    }
}
