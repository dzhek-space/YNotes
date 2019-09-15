//
//  AuthPresenter.swift
//  YNotes
//
//  Created by Dzhek on 20/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol AuthPresenterProtocol: class {
    
    var router: AuthRouterProtocol { get }
    var isTappedOfflineButton: Bool { get set }
    
    func configureView()
    func willDisappear()
    func startOnlineSession(as user: User)
    func startOfflineSession()
    func textFieldBeginEditing()
    func textFieldEndEditing()
    func didTapAround()
    func didTapNextKeyButton()
    func didTapSendKeyButton(_ user: User)
}

//MARK: - • Class

class AuthPresenter {
    
    //MARK: • Properties
    
    weak var authVC: AuthViewProtocol?
    let router: AuthRouterProtocol
    private let interactor: AuthInteractorProtocol
    
    let interfaceItem = AuthInterfaceItem()
    var isTappedOfflineButton: Bool = false
    
    //MARK: - • Methods
    
    init(interface: AuthViewProtocol,
         router: AuthRouterProtocol,
         interactor: AuthInteractorProtocol) {
        
        self.authVC = interface
        self.router = router
        self.interactor = interactor
    }
    
    private func login(as user: User) {
        self.authVC?.showLoading()

        let isLogin = self.interactor.fetchToken(for: user)
        if isLogin {
            self.authVC?.hideLoading()
            self.router.presentNotesList()
        } else {
            self.authVC?.showMessageScreen(.authFailed)
            self.authVC?.addTapGestureRecognizer()
        }
    }
    
    private func textFieldIsEmpty(_ user: User) -> Bool {
        let state = user.username!.isEmpty && user.password!.isEmpty
        return state
    }
    
}

    //MARK: -

extension AuthPresenter: AuthPresenterProtocol {
    
    func configureView() {
        self.authVC?.setupViews(with: interfaceItem)
    }
    
    func willDisappear() {
        self.authVC?.hideLoading()
    }
    
    func textFieldBeginEditing() {
        self.authVC?.addTapGestureRecognizer()
    }
    
    func textFieldEndEditing() {
        self.authVC?.removeGestureRecognizer()
    }
    
    func didTapNextKeyButton() {
        self.authVC?.setupNextResponder()
    }
    
    func didTapSendKeyButton(_ user: User) {
        self.authVC?.dismissKeyboard()
        self.startOnlineSession(as: user)
    }
    
    func didTapAround() {
        self.authVC?.removeGestureRecognizer()
        self.authVC?.hideMessageScreen()
        self.authVC?.dismissKeyboard()
    }
    
    func startOnlineSession(as user: User) {
        if !textFieldIsEmpty(user) {
            self.login(as: user)
        } else {
            self.authVC?.showMessageScreen(.emptyField)
            self.authVC?.addTapGestureRecognizer()
        }
    }
    
    func startOfflineSession() {
        self.isTappedOfflineButton = true
        self.router.presentNotesList()
    }
}
