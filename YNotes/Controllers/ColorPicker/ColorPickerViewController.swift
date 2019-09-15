//
//  ColorPickerViewController.swift
//  YNotes
//
//  Created by Dzhek on 02/09/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation
import FlexColorPicker

protocol ColorPickerViewProtocol: class {
    
    func setupViews(with title: String)
}

//MARK: - • Class

class ColorPickerViewController: DefaultColorPickerViewController {
    
    //MARK: • Properties
    
    let configurator: ColorPickerConfiguratorProtocol = ColorPickerConfigurator()
    var presenter: ColorPickerPresenterProtocol?
    
    private var cancelButton: UIBarButtonItem?
    private var doneButton: UIBarButtonItem?
    
    
    //MARK: - • LiveCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.configureView()
    }
    
    
    //MARK: - • Methods
    
    @objc private func doCancel() {
        self.presenter?.didTapCancelButton()
    }
    
    @objc private func doDone() {
        self.presenter?.confirmColor(as: selectedColor.hexValue)
        self.presenter?.didTapDoneButton()
    }
    
}

//MARK: - • Protocols implementation

extension ColorPickerViewController: ColorPickerDelegate {
    func colorPicker(_: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
        self.presenter?.confirmColor(as: selectedColor.hexValue)
    }
    
    func colorPicker(_: ColorPickerController, confirmedColor: UIColor, usingControl: ColorControl) {
        dismiss(animated: true, completion: nil)
    }
}

extension ColorPickerViewController: ColorPickerViewProtocol {

    func setupViews(with title: String) {
        let label = UILabel()
        self.navigationItem.titleView = label.setStyledTitle(title)
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = Palette.backgroundLight
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = Palette.primary
        self.navigationController?.navigationBar.barTintColor = Palette.navigationBackground
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doCancel))
        self.navigationItem.leftBarButtonItem = self.cancelButton
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doDone))
        self.navigationItem.rightBarButtonItem = self.doneButton
        if let color = self.presenter?.customColor {
            selectedColor = UIColor(hex: color)
        } else {
            selectedColor = .white
        }
        self.delegate = self
    }
}
