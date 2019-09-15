//
//  AuthViewController.swift
//  YNotes
//
//  Created by Dzhek on 12/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Protocol

protocol AuthViewProtocol: class {
    func setupViews(with item: AuthInterfaceItem)
    func showLoading()
    func hideLoading()
    func showMessageScreen(_ message: AuthErrorMessage)
    func hideMessageScreen()
    func addTapGestureRecognizer()
    func removeGestureRecognizer()
    func dismissKeyboard()
    func setupNextResponder()
}

    //MARK: - • Class

class AuthViewController: UIViewController {
    
    //MARK: • IBOutlets
    
    @IBOutlet weak var usernameTextField: StyledTextField!
    @IBOutlet weak var passwordTextField: StyledTextField!
    @IBOutlet weak var singInButton: StyledButton!
    @IBOutlet weak var offlineButton: StyledButton!
    
    
    //MARK: - • Properties
    
    private let authConfigurator: AuthConfiguratorProtocol = AuthConfigurator()
    var presenter: AuthPresenterProtocol?
    
    private lazy var loadingVC = LoadingViewController()
    private let mainQueue: OperationQueue = .main
    private var tapAroundGestureRecognizer: UITapGestureRecognizer?
    
    
    //MARK: - • LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authConfigurator.configureModule(with: self)
        self.presenter?.configureView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presenter?.willDisappear()
        super.viewWillDisappear(animated)
    }
    //MARK: - • Methods
    
    @objc private func didTapSingInButton() {
        let user = (username: self.usernameTextField.text, password: self.passwordTextField.text)
        self.presenter?.startOnlineSession(as: user)
    }
    
    @objc private func didTapOfflineButton() {
        self.presenter?.startOfflineSession()
    }
    
    @objc private func tapAroundAction() {
        self.presenter?.didTapAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let isOffLine = self.presenter?.isTappedOfflineButton
            else { return }
        self.presenter?.router.prepare(for: segue, stateSessoin: isOffLine)
    }
}

//MARK: - • Delegate implementation

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.presenter?.textFieldBeginEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.returnKeyType {
        case .next:
            self.presenter?.didTapNextKeyButton()
        case .send:
            let user = (username: self.usernameTextField.text, password: self.passwordTextField.text)
            self.presenter?.didTapSendKeyButton(user)
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.presenter?.textFieldEndEditing()
    }
    
}


//MARK: - • Protocol implementation

extension AuthViewController: AuthViewProtocol {
    
    func setupViews(with item: AuthInterfaceItem) {
        
        self.singInButton.setPrimaryStyle()
        self.singInButton.setTitle(item.singinButtonText, for: .normal)
        self.singInButton.addTarget(self, action: #selector(didTapSingInButton), for: .touchUpInside)
        
        self.offlineButton.setSecondaryStyle()
        self.offlineButton.setTitle(item.offlineButtonText, for: .normal)
        self.offlineButton.addTarget(self, action: #selector(didTapOfflineButton), for: .touchUpInside)
        
        self.usernameTextField.returnKeyType = .next
        self.usernameTextField.placeholder = item.usernamePlaceholder
        
        self.passwordTextField.returnKeyType = .send
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.placeholder = item.passwordPlaceholder
        
        self.view.backgroundColor = Palette.backgroundLight
    }

    func showLoading() {
        add(self.loadingVC)
    }
    
    func hideLoading() {
        self.loadingVC.remove()
    }
    
    func showMessageScreen(_ message: AuthErrorMessage) {
        self.hideLoading()
        let messageVC = MessageViewController()
        messageVC.message = message.rawValue
        add(messageVC)
    }
    
    func hideMessageScreen() {
        if let messageVC = self.children.first as? MessageViewController {
            self.passwordTextField.clear()
            messageVC.hideSelf()
        }
    }
    
    func setupNextResponder() {
        if let nextResponder = self.passwordTextField { nextResponder.becomeFirstResponder() }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func addTapGestureRecognizer() {
        if self.tapAroundGestureRecognizer == nil {
            self.tapAroundGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAroundAction))
            self.tapAroundGestureRecognizer!.cancelsTouchesInView = false
            self.view.addGestureRecognizer(self.tapAroundGestureRecognizer!)
        }
        
    }
    
    func removeGestureRecognizer() {
        if self.tapAroundGestureRecognizer != nil {
            self.view.removeGestureRecognizer(self.tapAroundGestureRecognizer!)
            self.tapAroundGestureRecognizer = nil
        }
    }

}
