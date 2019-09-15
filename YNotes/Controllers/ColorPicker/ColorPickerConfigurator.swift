//
//  ColorPickerConfigurator.swift
//  YNotes
//
//  Created by Dzhek on 02/09/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

protocol ColorPickerConfiguratorProtocol {
    func configureModule(with colorPickerVC: ColorPickerViewController)
}

//MARK: - • Class

final class ColorPickerConfigurator: ColorPickerConfiguratorProtocol {
    
    //MARK: • Methods
    
    func configureModule(with colorPickerVC: ColorPickerViewController) {
        let router = ColorPickerRouter()
        let presenter = ColorPickerPresenter(interface: colorPickerVC, router: router)
        
        colorPickerVC.presenter = presenter
        router.colorPickerVC = colorPickerVC
    }
    
}
