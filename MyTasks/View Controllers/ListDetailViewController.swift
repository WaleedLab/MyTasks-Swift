//
//  ListDetailViewController.swift
//  MyTasks
//
//  Created by Manu Safarov on 18.05.2021.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding tasks: Tasks)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing tasks: Tasks)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var tasksListToEdit: Tasks?
    var iconName = "ToDo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackButton")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackButton")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
        if let tasks = tasksListToEdit {
            title = "Edit Task"
            textField.text = tasks.name
            doneBarButton.isEnabled = true
            iconName = tasks.iconName
        }
        iconImage.image = UIImage(named: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "PickIcon" {
        let controller = segue.destination as! IconPickerViewController
        controller.delegate = self
      }
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let tasks = tasksListToEdit {
            tasks.name = textField.text!
            tasks.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: tasks)
        } else {
            let tasks = Tasks(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: tasks)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
    // MARK: - Icon Picker View Controller Delegate
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
      self.iconName = iconName
      iconImage.image = UIImage(named: iconName)
      navigationController?.popViewController(animated: true)
    }
}
