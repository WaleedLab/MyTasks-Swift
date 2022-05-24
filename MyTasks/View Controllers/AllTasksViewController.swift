//
//  AllTasksTableViewController.swift
//  MyTasks
//
//  Created by Manu Safarov on 16.05.2021.
//

import UIKit

class AllTasksViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    let cellIdentifier = "TasksCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        
        //Removing border in navigation VC
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //Customize back button navigation VC
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackButton")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackButton")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        //The user returns to the task from which the application was closed (to improve the UX)
        let index = dataModel.indexOfSelectedTask
        if index >= 0 && index < dataModel.lists.count {
            let tasks = dataModel.lists[index]
            performSegue(withIdentifier: "ShowTasks", sender: tasks)
        }
    }
    
        // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "ShowTasks" {
                let controller = segue.destination as! TaskListsViewController
                controller.tasks = sender as? Tasks
            } else if segue.identifier == "AddNewTask" {
                let controller = segue.destination as! ListDetailViewController
                controller.delegate = self
            }
        }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get cell
        let cell: UITableViewCell!
        if let tmp = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = tmp
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        // Update cell infromation
        let tasks = dataModel.lists[indexPath.row]
        let count = tasks.countUncheckedItems()
        
        cell.textLabel!.text = tasks.name
        cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 17)
        cell.accessoryType = .detailDisclosureButton
        cell.detailTextLabel?.font = UIFont(name: "Poppins-Medium", size: 11)
        cell.detailTextLabel?.textColor = UIColor(named: "detailTextColours")
        cell.selectionStyle = .none
        
        if tasks.items.count == 0 {
            cell.detailTextLabel!.text = "No Items"
        } else {
            cell.detailTextLabel!.text = count == 0 ? "All Done" : "\(count) Remaining"
        }
        cell.imageView!.image = UIImage(named: tasks.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedTask = indexPath.row
        
        let tasks = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowTasks", sender: tasks)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.dataModel.lists.remove(at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .right)
            completionHandler(true)
        }
        deleteAction.image = UIImage(named: "DeleteIcon")
        deleteAction.backgroundColor = UIColor(named: "secondMainColour")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let tasks = dataModel.lists[indexPath.row]
        controller.tasksListToEdit = tasks
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding tasks: Tasks) {
        dataModel.lists.append(tasks)
        dataModel.sortTasks()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing tasks: Tasks) {
        dataModel.sortTasks()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            dataModel.indexOfSelectedTask = -1
        }
    }
}
