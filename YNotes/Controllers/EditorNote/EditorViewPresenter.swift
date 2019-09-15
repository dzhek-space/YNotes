//
//  EditingNotePresenter.swift
//  YNotes
//
//  Created by Dzhek on 26/08/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import Foundation

//MARK: - • Protocol

typealias DoubleStringTuple = (String, String)

protocol EditorViewPresenterProtocol: class {
    
    var router: EditorViewRouterProtocol { get }

    var interfaceItem: EditorInterfaceItem { get }
    var minimumDateForPicker: Date { get }
    var colors: [String?] { get }
    var titleNotes: String { get set }
    var contentNotes: String { get set }
    var color: String { get set }
    var importance: String { get set }
    var selfDestructionDate: Date? { get set }
    
    func receive(note: Note?)
    func configureView()
    func updateView()
    func viewDidAppear()
    func textDidBeginEditing()
    func textDidEndEditing()
    func coltrolStateSaveButton() -> Bool
    func didTapForDismissKeyboard()
    func didTapSwitch(state: Bool)
    func formatDate(_ date:Date) -> String
    func controlStatesDatePickerButton(with date: Date) -> Bool
    func controlStatesDatePicker(currentDateLabelText: String)
    func eventHandlingCheckSquare(with index: Int?, isBegan: Bool)
    func didTapSegmentedControl(with index: Int)
    func saveNote(save textInfo: DoubleStringTuple)
    func didTapCancelButton()
    func viewWillDisappear()

}

protocol EditorViewInputProtocol: class {
    func receive(note: Note?)
    func recive(customColor: String)
}

//MARK: - • Class

class EditorViewPresenter {
    
    //MARK: • Properties
    
    weak var editorVC: EditorViewProtocol?
    let router: EditorViewRouterProtocol
    
    private var note: Note?
    private var isNoteExists: Bool { return self.note != nil ? true : false }
    private var defaultColors: [String?] = [Palette.white.hexValue, Palette.green.hexValue, Palette.gold.hexValue, Palette.blue.hexValue, nil]
    var customColor: String?
    var colors: [String?] {
        let lastIndex = defaultColors.count - 1
        if self.customColor == nil {
            let color = self.defaultColors.first{ $0 == self.note?.color.hexValue }
            let lastColor: String? = color == nil ? self.note?.color.hexValue : nil
            if lastColor != nil {
                defaultColors[lastIndex] = lastColor
            }
        } else {
            defaultColors[lastIndex] = self.customColor
        }
        
        return defaultColors
    }
    let interfaceItem = EditorInterfaceItem()
    let minimumDateForPicker = Date()
    
    lazy var titleNotes: String = self.isNoteExists ? self.note!.title : ""
    lazy var contentNotes: String = self.isNoteExists ? self.note!.content : ""
    lazy var color: String = self.isNoteExists ? self.note!.color.hexValue : Palette.white.hexValue
    lazy var importance: String = self.isNoteExists ? self.note!.importance.rawValue : Priorities.medium.rawValue
    lazy var selfDestructionDate: Date? = self.isNoteExists ? self.note?.selfDestructionDate : nil
    
    var dictionaryNote: [String: String?] {
       return [ "uid": note?.uid,
                "title": titleNotes,
                "content": contentNotes,
                "color": color,
                "importance": importance ]
    }

    
    //MARK: - • Methods
    
    init(interface: EditorViewProtocol,
         router: EditorViewRouterProtocol) {
        
        self.editorVC = interface
        self.router = router
    }
    
}


//MARK: - • Protocol implementation

extension EditorViewPresenter: EditorViewPresenterProtocol {
    
    func configureView() {
        let titleVC = self.interfaceItem.titleVC(self.isNoteExists)
        self.editorVC?.setupViews(with: titleVC)
        self.editorVC?.updateColorSquare()
    }
    
    func updateView() {
        if self.customColor != nil {
            let colorIndex = self.colors.firstIndex(of: self.customColor)
            self.eventHandlingCheckSquare(with: colorIndex, isBegan: false)
        } else {
            if self.isNoteExists {
                self.editorVC?.fillWithData()
                if selfDestructionDate != nil {
                    self.didTapSwitch(state: true)
                    self.editorVC?.toggleDateSwitch()
                }
                let colorIndex = self.colors.firstIndex(of: self.note?.color.hexValue)
                self.eventHandlingCheckSquare(with: colorIndex, isBegan: false)
                let priorities = self.interfaceItem.notePriorities
                if let priorityIndex = priorities.firstIndex(of: self.note!.importance.rawValue) {
                    self.editorVC?.toggleSegmentedControl(to: priorityIndex)
                }
            } else {
                self.eventHandlingCheckSquare(with: nil, isBegan: false)
            }
        }
        
    }
    
    func viewDidAppear() {
        self.editorVC?.finalSetupView()
    }
    
    func viewWillDisappear() {
        self.editorVC?.willDisappear()
    }
 
    func textDidBeginEditing() {
        self.editorVC?.addTapGestureRecognizer()
    }
    
    func textDidEndEditing() {
        self.editorVC?.removeGestureRecognizer()
    }
    
    func didTapForDismissKeyboard() {
        self.editorVC?.removeGestureRecognizer()
        self.editorVC?.dismissKeyboard()
    }
    
    func didTapSwitch(state: Bool) {
        self.editorVC?.removeGestureRecognizer()
        self.editorVC?.dismissKeyboard()
        self.editorVC?.toggleStateDestructionDateStack(isShow: state)
        if !state {
            self.selfDestructionDate = nil
        }
    }
    
    func formatDate(_ date: Date) -> String {
        self.selfDestructionDate = date
        self.editorVC?.toggleStateDatePicker()
        return date.asString()
    }
    
    func controlStatesDatePickerButton(with date: Date) -> Bool {
        let state = date > self.minimumDateForPicker
        return state
    }
    
    func controlStatesDatePicker(currentDateLabelText: String) {
        let defaultText = self.interfaceItem.defaultDestructionDateLabelText
        if currentDateLabelText != defaultText {
            self.editorVC?.toggleStateDatePicker()
            self.editorVC?.dismissKeyboard()
        } else {
            self.editorVC?.toggleStateDestructionDateStack(isShow: false)
            self.editorVC?.toggleDateSwitch()
        }
    }
    
    func coltrolStateSaveButton() -> Bool {
        return self.editorVC?.textViewState ?? false
    }
    
    func eventHandlingCheckSquare(with index: Int?, isBegan: Bool) {
        let lastColorIndex = colors.compactMap{ $0 }.count - 1
        switch index {
            case nil:
                self.editorVC?.checkSquere(with: 0)
                self.color = colors[0]!
            default:
                if isBegan {
                    let condition = colors.last! != nil
                    let initialColor = condition ? colors.last! : defaultColors.first!
                    self.router.presentColorPickerViewController(hexInitialColor: initialColor!)
                } else if (0 ... lastColorIndex).contains(index!) {
                    self.editorVC?.checkSquere(with: index!)
                    self.color = colors[index!]!
                }
        }
    }
    
    func didTapSegmentedControl(with index: Int) {
        let priorities = self.interfaceItem.notePriorities
        self.importance = priorities[index]
    }
    
    func saveNote(save textInfo: DoubleStringTuple) {
        self.titleNotes = textInfo.0
        self.contentNotes = textInfo.1
        
        let rawNote: RawNote
        if isNoteExists {
            rawNote = RawNote(uid: self.note?.uid,
                              title: self.titleNotes,
                              content: self.contentNotes,
                              color: self.color,
                              importance: self.importance,
                              selfDestructionDate: self.selfDestructionDate,
                              lastEditedDate: Date())
        } else {
            rawNote = RawNote(title: self.titleNotes,
                              content: self.contentNotes,
                              color: self.color,
                              importance: self.importance,
                              selfDestructionDate: self.selfDestructionDate,
                              lastEditedDate: Date())
        }

        self.router.prepareToPop(with: rawNote.converted, isNew: !isNoteExists)
        self.router.popTableViewController()
    }
    
    func didTapCancelButton() {
        self.router.popTableViewController()
    }
}

extension EditorViewPresenter: EditorViewInputProtocol {
    
    func receive(note: Note?) {
        self.note = note
    }
    
    func recive(customColor: String) {
        self.customColor = customColor
        self.editorVC?.updateColorSquare()
    }
}

