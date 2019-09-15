//
//  ViewController.swift
//  NoteEditor
//
//  Created by Dzhek on 23/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Protocol

protocol EditorViewProtocol: class {
    
    var textViewState: Bool { get }
    
    func setupViews(with title: String)
    func finalSetupView()
    func willDisappear()
    func fillWithData()
    func updateColorSquare()
    func addTapGestureRecognizer()
    func removeGestureRecognizer()
    func dismissKeyboard()
    func toggleStateDatePicker()
    func toggleStateDestructionDateStack(isShow: Bool)
    func toggleDateSwitch()
    func checkSquere(with index: Int)
    func toggleSegmentedControl(to index: Int)
}


//MARK: - • Class

class EditorViewController: UIViewController {
    
    //MARK: • IBOutlets
    
    @IBOutlet weak var titleNoteLabel: EditorSceneLabel!
    @IBOutlet weak var conlentNoteLabel: EditorSceneLabel!
    @IBOutlet weak var switchLabel: EditorSceneLabel!
    @IBOutlet weak var descriptionDateLabel: EditorSceneLabel!
    @IBOutlet weak var destructionDateLabel: EditorSceneLabel!
    @IBOutlet weak var colorSetLabel: EditorSceneLabel!
    @IBOutlet weak var priorityLabel: EditorSceneLabel!
    @IBOutlet weak var datePickerButton: StyledButton!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var titleNoteTextView: UITextView!
    @IBOutlet weak var contentNoteTextView: UITextView!
    
    @IBOutlet weak var destructionDateSwitch: UISwitch!
    @IBOutlet weak var dateLabelsStackView: UIStackView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var squareStackView: UIStackView!
    @IBOutlet weak var prioritySegmentedControl: PrioritySegmentedControl!
    

    //MARK: - • Properties

    let configurator: EditorViewConfiguratorProtocol = EditorViewConfigurator()
    var presenter: EditorViewPresenterProtocol?
    private var keyboardDismissTapGesture: UIGestureRecognizer?
    private var cancelButton: UIBarButtonItem?
    private var saveButton: UIBarButtonItem?
    
    private let check = CheckView()
    private let inset = Constants.inset
    
    
    //MARK: - • IBActions
    
    @IBAction func tapSwitch(_ sender: UISwitch) {
        self.presenter?.didTapSwitch(state: sender.isOn)
        self.setSaveButtonState()
    }

    @IBAction func toggleDatePicker(_ sender: UITapGestureRecognizer) {
        self.presenter?.controlStatesDatePicker(currentDateLabelText: self.destructionDateLabel.text!)
    }
    
    @IBAction func toggleStateDatePickerButton(_ sender: UIDatePicker) {
        if let isEnabel = self.presenter?.controlStatesDatePickerButton(with: sender.date) {
            self.datePickerButton.isEnabled = isEnabel
        }
        self.setSaveButtonState()
    }
    
    @IBAction func setDestroyDate(_ sender: UIButton) {
        self.destructionDateLabel.text = self.presenter?.formatDate(self.datePicker.date)
        self.setSaveButtonState()
    }
    
    @IBAction func didTapSquare(_ recognizer: UITapGestureRecognizer) {
        let isBegan = recognizer.state == .began ? true : false
        let squares = self.squareStackView.subviews
        for square in squares {
            if square.frame == recognizer.view?.frame {
                let index: Int? = squares.firstIndex(of: square)
                self.presenter?.eventHandlingCheckSquare(with: index, isBegan: isBegan)
            }
        }
        self.setSaveButtonState()
    }
    
    
    //MARK: - • LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.presenter?.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.presenter?.viewWillDisappear()
        super.viewWillDisappear(animated)
    }
    
    
    //MARK: - • Methods
    
    private func setupColorSquare() {
        let squares = self.squareStackView.subviews
        for i in 0 ..< squares.count {
            let square = squares[i] as! ColoredSquareView
            if let color = self.presenter?.colors[i] {
                square.colorize(backgroundColor: UIColor(hex: color))
            } else {
                square.colorize(backgroundColor: nil)
            }
            
        }
    }

    
    // Correct view so that the 'pickerView' is visible,
    // '2' – index 'pickerView'
    private func scrollCorrection() {
        if !self.pickerView.isHidden {
            let heigtToScroll = self.mainScrollView.subviews[2].frame.maxY
            let frame = CGRect(x: 0, y: 0, width: self.mainScrollView.frame.width, height: heigtToScroll)
            self.mainScrollView.scrollRectToVisible(frame, animated: true)
        }
    }
    
    @objc private func doCancel() {
        self.presenter?.didTapCancelButton()
    }
    
    private func setSaveButtonState() {
        if let isOn = self.presenter?.coltrolStateSaveButton() {
            self.saveButton?.isEnabled = isOn
        }
    }
    
    @objc private func doSave() {
        let tetxInfo =  (self.titleNoteTextView.text!, self.contentNoteTextView.text!)
        self.presenter?.saveNote(save: tetxInfo)
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        let segmentIndex = sender.selectedSegmentIndex
        self.presenter?.didTapSegmentedControl(with: segmentIndex)
        self.setSaveButtonState()
    }

    
}


// MARK: - • TextView & Keyboard implementation

extension EditorViewController: UITextViewDelegate {
    
    var textViewState: Bool {
        let state = !self.titleNoteTextView.text.isEmpty && !self.contentNoteTextView.text.isEmpty
        return state
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.presenter?.textDidBeginEditing()
        self.setSaveButtonState()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.presenter?.textDidEndEditing()
        self.setSaveButtonState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.setSaveButtonState()
    }
    
    private func launchObserverKeyboard() {
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(keyboardWillShow),
                       name: UIResponder.keyboardWillShowNotification,
                       object: nil)
        nc.addObserver(self,
                       selector: #selector(keyboardWillHide),
                       name: UIResponder.keyboardWillHideNotification,
                       object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let key = UIResponder.keyboardFrameEndUserInfoKey
        guard let frameValue = notification.userInfo?[key] as? NSValue
            else { return }
        
        let frame = frameValue.cgRectValue
        self.mainScrollView.contentInset.bottom = frame.size.height + inset / 2
        self.mainScrollView.scrollIndicatorInsets.bottom = frame.size.height + inset / 2
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.mainScrollView.contentInset.bottom = 0
        self.mainScrollView.scrollIndicatorInsets.bottom = 0
    }
    
    @objc private func tapForDismissKeyboard() {
        self.presenter?.didTapForDismissKeyboard()
    }
    
}


// MARK: - • Protocols implementation

extension EditorViewController: EditorViewProtocol {

    func setupViews(with title: String) {
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = Palette.backgroundLight
        self.navigationController?.navigationBar.tintColor = Palette.primary
        self.navigationController?.navigationBar.barTintColor = Palette.navigationBackground
        self.cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doCancel))
        self.navigationItem.leftBarButtonItem = self.cancelButton
        self.saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(doSave))
        self.navigationItem.rightBarButtonItem = self.saveButton
        
        guard let presenter = self.presenter
            else { logDebug("Edit_View_Controller has no presenter")
                   return }
        
        let label = UILabel()
        self.navigationItem.titleView = label.setStyledTitle(title)
        self.titleNoteLabel.text = presenter.interfaceItem.titleNoteLabelText
        self.conlentNoteLabel.text = presenter.interfaceItem.contentNoteLabelText
        self.switchLabel.text = presenter.interfaceItem.switchLabelText
        self.descriptionDateLabel.configureDangerStyle()
        self.descriptionDateLabel.text = presenter.interfaceItem.descriptionDateLabelText
        self.destructionDateLabel.configureDangerStyle()
        self.destructionDateLabel.text = presenter.interfaceItem.defaultDestructionDateLabelText
        self.destructionDateSwitch.onTintColor = Palette.danger
        self.datePicker.minimumDate = presenter.minimumDateForPicker
        self.datePickerButton.setSecondaryStyle()
        self.datePickerButton.setTitle(presenter.interfaceItem.datePickerButtonDisableTitle, for: .disabled)
        self.datePickerButton.setTitle(presenter.interfaceItem.datePickerButtonNormalTitle, for: .normal)
        self.colorSetLabel.text = presenter.interfaceItem.colorSetLabelText
        self.priorityLabel.text = presenter.interfaceItem.priorityLabelText
        self.prioritySegmentedControl.configure(with: presenter.interfaceItem.notePriorities)
        self.prioritySegmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)),
                                                for: .valueChanged)
        self.setSaveButtonState()
    }
    
    func finalSetupView() {
        self.tabBarController?.tabBar.isHidden = true
        self.launchObserverKeyboard()
    }
    
    func updateColorSquare() {
        self.setupColorSquare()
    }
    
    func willDisappear() {
        NotificationCenter.default.removeObserver(self)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func fillWithData() {
        self.titleNoteTextView.text = self.presenter?.titleNotes
        self.contentNoteTextView.text = self.presenter?.contentNotes
        self.destructionDateLabel.text = self.presenter?.selfDestructionDate != nil
                                        ? self.presenter?.selfDestructionDate?.asString()
                                        : self.presenter?.interfaceItem.defaultDestructionDateLabelText
        
    }
    
    func addTapGestureRecognizer() {
        if self.keyboardDismissTapGesture == nil {
            self.keyboardDismissTapGesture = UITapGestureRecognizer(target: self,
                                                                    action: #selector(tapForDismissKeyboard))
            self.keyboardDismissTapGesture!.cancelsTouchesInView = false
            self.view.addGestureRecognizer(self.keyboardDismissTapGesture!)
        }
    }
    
    func removeGestureRecognizer() {
        if self.keyboardDismissTapGesture != nil {
            self.view.removeGestureRecognizer(self.keyboardDismissTapGesture!)
            self.keyboardDismissTapGesture = nil
        }
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func toggleStateDatePicker() {
        let show = !self.pickerView.isHidden
        UIView.animate(withDuration: 0.2, animations: {
            self.pickerView.isHidden = show
            self.pickerView.alpha = show ? 0 : 1
        })
    }
    
    func toggleStateDestructionDateStack(isShow: Bool) {
        
        let defaultText = self.presenter?.interfaceItem.defaultDestructionDateLabelText
        let isDefaultLabelText = self.destructionDateLabel.text == defaultText
        let conditionForClosing = !isShow && !self.pickerView.isHidden
        let conditionForOpening = isShow && isDefaultLabelText
        
        UIView.animate(withDuration: 0.15, animations: {
            self.dateLabelsStackView.isHidden = !isShow
            self.dateLabelsStackView.alpha = !isShow ? 0 : 1
            if conditionForClosing || conditionForOpening {
                self.toggleStateDatePicker()
            }
            if !isShow {
                self.destructionDateLabel.text = defaultText
            }
        }) { _ in self.scrollCorrection() }
    }
    
    func toggleDateSwitch() {
        self.destructionDateSwitch.isOn = self.destructionDateSwitch.isOn ? false : true
    }
    
    func checkSquere(with index: Int) {
        let squares = self.squareStackView.subviews
        squares[index].addSubview(check)
    }
    
    func toggleSegmentedControl(to index: Int) {
        self.prioritySegmentedControl.selectedSegmentIndex = index
    }
}
