//
//  ColorPickerRouter.swift
//  YNotes
//
//  Created by Dzhek on 02/09/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Protocol

protocol ColorPickerRouterProtocol {
    
    func popEditorViewController()
    func prepareToPop(with hexColor: String)
}

//MARK: - • Class

class ColorPickerRouter: ColorPickerRouterProtocol {
    
    //MARK: • Properties
    
    weak var colorPickerVC: ColorPickerViewController?
    private let mainQueue: OperationQueue = .main
    
    
    //MARK: - • Methods
    
    func popEditorViewController() {
        self.mainQueue.addOperation {
            self.colorPickerVC?.navigationController?.popViewController(animated: true)
        }
    }
    
    func prepareToPop(with hexColor: String) {
        let editorVC = colorPickerVC?.parent?.children[1] as? EditorViewController
        let editorVCPresenter = editorVC?.presenter as! EditorViewInputProtocol
        editorVCPresenter.recive(customColor: hexColor)
        self.popEditorViewController()
    }
    
}
