//
//  LoadingViewController.swift
//  GetGists
//
//  Created by Dzhek on 09/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Class

class LoadingViewController: UIViewController {
    
    //MARK: • Properties
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray)
    private lazy var backgroundView = UIView()

    
    //MARK: - • LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .none
        self.setupView()
        self.setupActivityIndicator()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
            UIView.animate(withDuration: 0.2, animations: {
                self?.backgroundView.layer.opacity = 1
                self?.activityIndicator.startAnimating()
            })
        }
    }
    
    //MARK: - • Methods
    
    private func setupView() {
        
        self.backgroundView.backgroundColor = UIColor.white
        self.backgroundView.layer.opacity = 0
        self.view.addSubview(backgroundView)
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.backgroundView.widthAnchor.constraint(equalToConstant: self.view.frame.width),
            self.backgroundView.heightAnchor.constraint(equalToConstant: self.view.frame.height),
            self.backgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.backgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            ])
    }
    
    private func setupActivityIndicator() {
        
        self.backgroundView.addSubview(activityIndicator)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        let constantAnchor = self.view.frame.height / 3
        NSLayoutConstraint.activate ([
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor, constant: constantAnchor)
            ])
    }

}
