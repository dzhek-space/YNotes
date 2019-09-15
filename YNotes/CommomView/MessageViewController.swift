//
//  ErrorViewController.swift
//  YNotes
//
//  Created by Dzhek on 21/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

class MessageViewController: UIViewController {
    
     //MARK: • Properties

    private lazy var errorLabel = UILabel()
    private lazy var backgroundView = UIView()
    private lazy var messageLabel = UILabel()
    private lazy var closeLabel = UILabel()
    
    private let inset: CGFloat = 32.0
    var message: String?
    var millisecondDelayDuration: Int?
    
    
    //MARK: - • LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupMessageLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.layer.opacity = 1
                self.messageLabel.layer.opacity = 0.6
                self.closeLabel.layer.opacity = 0.6
            })
    }
    
    
     //MARK: - • Methods
    
    func hideSelf() {
        UIView.animate(withDuration: 0.2,
                       animations: { self.backgroundView.layer.opacity = 0 },
                       completion: {_ in self.remove() }
        )
    }

    private func setupView() {
        
        self.view.backgroundColor = .clear
        
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.layer.opacity = 0
        self.view.addSubview(backgroundView)
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.closeLabel.setInfoStyle()
        self.closeLabel.text = "tap to close"
        self.closeLabel.textAlignment = .center
        self.backgroundView.layer.opacity = 0
        self.backgroundView.addSubview(closeLabel)
        self.closeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backgroundView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            self.backgroundView.heightAnchor.constraint(equalToConstant: self.view.frame.height),
            self.backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.backgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.closeLabel.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: inset),
            self.closeLabel.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -inset),
            self.closeLabel.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -inset)
            ])
    }
    
    private func setupMessageLabel() {
        self.messageLabel.setDangerStyle(font: UIFont.boldSystemFont(ofSize: 16), lines: 3)
        self.messageLabel.text = self.message
        self.messageLabel.textAlignment = .center
        self.messageLabel.layer.opacity = 0
        self.backgroundView.addSubview(self.messageLabel)
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let constantAnchor = self.view.frame.height / 3
        NSLayoutConstraint.activate ([
            self.messageLabel.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: inset),
            self.messageLabel.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -inset),
            self.messageLabel.topAnchor.constraint(equalTo: self.backgroundView.topAnchor, constant: constantAnchor)
            ])
    }
    
}

