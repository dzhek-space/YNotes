//
//  ColorPickerPresenter.swift
//  YNotes
//
//  Created by Dzhek on 02/09/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol ColorPickerPresenterProtocol: class {
    
    var router: ColorPickerRouterProtocol { get }
    var customColor: String? { get }
    
    func confirmColor(as hexColor: String)
    func configureView()
    func didTapCancelButton()
    func didTapDoneButton()

}

//MARK: - • Class

class ColorPickerPresenter {
    
    //MARK: • Properties
    
    weak var colorPickerVC: ColorPickerViewProtocol?
    let router: ColorPickerRouterProtocol
    
    var customColor: String? = Palette.white.hexValue
    let colorPickerItem = ColorPickerInterfaceItem()
    
    //MARK: - • Methods
    
    init(interface: ColorPickerViewProtocol,
         router: ColorPickerRouterProtocol) {
        
        self.colorPickerVC = interface
        self.router = router
    }
    
}


//MARK: - • Protocols implementation

extension ColorPickerPresenter: ColorPickerPresenterProtocol {
    
    func configureView() {
        self.colorPickerVC?.setupViews(with: self.colorPickerItem.titleLabelText)
    }
    
    func confirmColor(as hexColor: String) {
        self.customColor = hexColor
    }
    
    func didTapCancelButton() {
        self.router.popEditorViewController()
    }
    
    func didTapDoneButton() {
        self.router.prepareToPop(with: self.customColor!)
    }
}
