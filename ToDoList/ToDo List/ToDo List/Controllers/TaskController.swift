//
//  TaskController.swift
//  ToDo List
//
//  Created by 12345 on 04.11.2021.
//

import UIKit

class TaskController {
    
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    
    func getAllTasks() -> [Task]{
        return tasks
    }
    
    func add(new task: Task) {
        tasks.append(task)
        
        saveTasksToLocalStorage()
    }
    
    func remove(by index: Int) {
        tasks.remove(at: index)
        
        saveTasksToLocalStorage()
    }
    
    func taskCount() -> Int {
        return tasks.count
    }
    
    func task(by index: Int) -> Task {
        return tasks[index]
    }
    
    func search(by title: String) -> [Task] {
        return tasks.filter { task in
            (task.title != nil) ? task.title!.contains(title) : false
        }
    }
    
    func sortByDateNewest() -> [Task] {
        tasks.sort { task1, task2 in
            task1.createdDate < task2.createdDate
        }
        return tasks
    }
    
    func sorthByDateOldest() -> [Task] {
        tasks.sort { task1, task2 in
            task1.createdDate > task2.createdDate
        }
        return tasks
    }
    
    func sortByTaskCompletionDate() -> [Task] {
        tasks.sort { task1, task2 in
            task1.taskDate < task2.taskDate
        }
        return tasks
    }
    
    func sortByTitleAlphabetically() -> [Task] {
        let sortedArray = tasks.filter({ task in
            task.title != nil
        }).sorted (by: { task1, task2 in
            task1.title! < task2.title!
        })
        return sortedArray
    }
    
    func saveTasksToLocalStorage() {
        var tasksParsedDicts: [[String : Any]] = []
        
        tasks.forEach { task in
            tasksParsedDicts.append(task.toDict())
        }
        UserDefaults.standard.set(tasksParsedDicts, forKey: "tasksParsedDicts")
    }
    
    func reedFromLocalStorage() {
        guard let tasksParsedDicts = UserDefaults.standard.value(forKey: "tasksParsedDicts") as? [[String : Any]] else {return}
        
        var tasks: [Task] = []
        
        tasksParsedDicts.forEach { dict in
            tasks.append(Task.reed(from: dict))
        }
        self.tasks = tasks
    }
    
}
