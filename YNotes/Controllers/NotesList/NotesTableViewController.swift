//
//  NotesTableViewController.swift
//  YNotes
//
//  Created by Dzhek on 18/07/2019.
//  Copyright © 2019 Dzhek. All rights reserved.
//

import UIKit

//MARK: - • Protocol

protocol NotesTableViewInput {
    var presenter: NotesTablePresenterProtocol? { get }
}

protocol NotesTableViewProtocol: class {
    
    func setupViews()
    func setupTableTitle(as title: String)
    func showLoader()
    func hideLoader()
    func updateViews()
    func togleStateLeftBarButtonItem()
    func showMessage(_ message: NotesTableMessage)
    func hideMessage()
    func makeCellTransition()
    func insertRow()
    func makeDelete()
}

//MARK: - • Class

class NotesTableViewController: UITableViewController, NotesTableViewInput {
    
    //MARK: • Properties
    
    let configurator: NotesTableConfiguratorProtocol = NotesTableConfigurator()
    var presenter: NotesTablePresenterProtocol?
    
    private let loadingVC = LoadingViewController()
    private var editButton: UIBarButtonItem?
    private var addButton: UIBarButtonItem?
    private var selectedRowIndex: IndexPath?
    private let mainQueue = OperationQueue.main
    

    //MARK: - • LiveCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    

    //MARK: - • Methods
    
    @objc private func doEdit() {
        let which = self.buttonEditState()
        self.editButton = UIBarButtonItem(barButtonSystemItem: which, target: self, action: #selector(doEdit))
        self.navigationItem.leftBarButtonItem = self.editButton
    }
    
    private func buttonEditState() -> UIBarButtonItem.SystemItem {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
            return .edit
        } else {
            self.tableView.setEditing(true, animated: true)
            return .done
        }
    }
    
    @objc private func doAdd() {
        self.presenter?.addNewNote()
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let number = self.presenter?.notes.count
            else { return 0 }
        if number == 0, self.tableView.isEditing { self.doEdit() }
        return number
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        cell.configureStyle()
        if let note = self.presenter?.notes[indexPath.row] {
            cell.titleLabel.text = note.title
            cell.contentLabel.text = note.content
            cell.date.text = note.selfDestructionDate?.asString()
            cell.colorOfNoteView.backgroundColor = note.color
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        guard let note = self.presenter?.notes[indexPath.row]
            else { return }
        self.selectedRowIndex = indexPath
        self.presenter?.remove(note)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var note: Note?
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            self.selectedRowIndex = indexPath
            note = self.presenter?.notes[indexPath.row]
        }
        
        self.presenter?.router.prepare(for: segue, note: note)

    }
    
}


//MARK: - • Protocol implementation

extension NotesTableViewController: NotesTableViewProtocol {
    
    func makeDelete() {
        self.mainQueue.addOperation {
            self.tableView.deleteRows(at: [self.selectedRowIndex!], with: .automatic)
        }
    }
    
    func makeCellTransition() {
        self.mainQueue.addOperation {
            let indexPath = IndexPath(row: 0, section: 0)
            let oldIndexPath = self.selectedRowIndex
            if oldIndexPath != nil, indexPath != oldIndexPath {
                self.tableView.moveRow(at: oldIndexPath!, to: indexPath)
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func insertRow() {
        self.mainQueue.addOperation {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func showLoader() {
        add(self.loadingVC)
    }
    
    func hideLoader() {
        self.loadingVC.remove()
    }
    
    func showMessage(_ message: NotesTableMessage) {
        self.hideLoader()
        self.mainQueue.addOperation {
            let messageVC = MessageViewController()
            messageVC.message = message.rawValue
            self.add(messageVC)
        }
    }
    
    func hideMessage() {
        self.mainQueue.addOperation {
            if let messageVC = self.children.first as? MessageViewController {
                messageVC.hideSelf()
            }
        }
        
    }
    
    func togleStateLeftBarButtonItem() {
        self.mainQueue.addOperation {
            let disableState = self.tableView.numberOfRows(inSection: 0) == 0
            if disableState {
                self.editButton?.isEnabled = false
            } else {
                self.editButton?.isEnabled = true
            }
            
        }
    }
    
    func updateViews() {
        self.mainQueue.addOperation {
            self.hideLoader()
            self.tableView.reloadData()
        }
    }
    
    func setupViews() {
        self.navigationController?.navigationBar.tintColor = Palette.primary
        self.navigationController?.navigationBar.barTintColor = Palette.navigationBackground
        
        self.editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(doEdit))
        self.navigationItem.leftBarButtonItem = self.editButton
        
        self.addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doAdd))
        self.navigationItem.rightBarButtonItem = self.addButton
        
        self.tableView.backgroundColor = Palette.backgroundLight
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.tableFooterView = UIView()
        
    }
    
    func setupTableTitle(as title: String) {
        let label = UILabel()
        self.navigationItem.titleView = label.setStyledTitle(title)
    }
    
}
