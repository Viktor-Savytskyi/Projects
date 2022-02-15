//
//  TaskListViewController.swift
//  ToDo List
//
//  Created by 12345 on 24.10.2021.
//

import UIKit

class TaskListViewController: BaseViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let taskController = TaskController()
    let filteredTaskController = FilteredTaskController()
    var selectedTypeSort: SortingType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskController.reedFromLocalStorage()
        prepareTableView()
        prepareSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        filteredTaskController.setArrayOfData(get: taskController.getAllTasks())
        tableView.reloadData()
        prepareNavigationBar()
    }
    
    func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sender = sender else { return }
        if let taskViewController = segue.destination as? TaskViewController {
            taskViewController.completion = { task in
                self.taskController.add(new: task)
                self.tableView.reloadData()
            }
        }
        
        if let sortedViewController = segue.destination as? SortedViewController {
            sortedViewController.completion = { sortBy in
                if sortBy == .sortByCreateDateFromNewestToOldest {
                    self.filteredTaskController.sortByDateNewest()
                    self.selectedTypeSort = sortBy
                } else if sortBy == .sortByCreateDateFromOldestToNewest {
                    self.filteredTaskController.sortByDateOldest()
                    self.selectedTypeSort = sortBy
                } else if sortBy == .sortByTitleFromAToZ {
                    self.filteredTaskController.setArrayOfData(get:self.filteredTaskController.sortByTitleAlphabetically())
                    self.selectedTypeSort = sortBy
                } else if sortBy == .sortByTitleFromZToA {
                    self.filteredTaskController.setArrayOfData(get:self.filteredTaskController.sortByTitleAlphabeticallyInReverseOrder())
                    self.selectedTypeSort = sortBy
                }
                else if sortBy == .sortByComplatingTasks {
                    self.filteredTaskController.setArrayOfData(get:self.filteredTaskController.sortByComplated())
                    self.selectedTypeSort = sortBy
                } else if sortBy == .sortByNotComplatingTasks {
                    self.filteredTaskController.setArrayOfData(get:self.filteredTaskController.sortByNotComplated())
                    self.selectedTypeSort = sortBy
                }
                else if sortBy == .sortByTaskExecutionDate {
                    self.filteredTaskController.sortByExecutionDate()
                    self.selectedTypeSort = sortBy
                }
                self.tableView.reloadData()
            }
            sortedViewController.sortType = self.selectedTypeSort
        }
    }
    
    func prepareSearchBar() {
        searchBar.delegate = self
    }
    
    func prepareNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTaskController.useEmptyArray()
        if searchText == "" {
            filteredTaskController.setArrayOfData(get: taskController.getAllTasks())
        } else {
            for task in taskController.getAllTasks() {
                if task.title!.lowercased().contains(searchText.lowercased()) {
                    filteredTaskController.addFilteredTask(new: task)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
    
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredTaskController.taskCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        cell.fill(with: filteredTaskController.task(by: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editingAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, hendler) in
            let taskViewController = self.storyboard?.instantiateViewController(withIdentifier: "taskViewController") as! TaskViewController
            taskViewController.task = self.taskController.task(by: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(taskViewController, animated: true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, hendler) in
            self.taskController.remove(by: indexPath.row)
            self.filteredTaskController.remove(by: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        let configuration = UISwipeActionsConfiguration(actions:[editingAction, deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredTaskController.task(by: indexPath.row).status == false {
            filteredTaskController.task(by: indexPath.row).status = true
        } else if filteredTaskController.task(by: indexPath.row).status == true {
            filteredTaskController.task(by: indexPath.row).status = false
        }
        taskController.saveTasksToLocalStorage()
        tableView.reloadData()
    }
}
