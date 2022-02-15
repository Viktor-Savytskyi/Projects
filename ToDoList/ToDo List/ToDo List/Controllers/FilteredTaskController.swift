//
//  FilteredTaskController.swift
//  ToDo List
//
//  Created by 12345 on 12.12.2021.
//

import Foundation

class FilteredTaskController {
    
    private var filteredTasks: [Task] = []
    
    func addFilteredTask(new task: Task) {
        filteredTasks.append(task)
    }
    
    func getAllTasks() -> [Task]{
        return filteredTasks
    }
    
    func taskCount() -> Int {
        return filteredTasks.count
    }
    
    func task(by index: Int) -> Task {
        return filteredTasks[index]
    }
    
    func remove(by index: Int) {
        filteredTasks.remove(at: index)
    }
    
    func setArrayOfData(get array: [Task]) {
        filteredTasks = array
    }
    
    func useEmptyArray() {
        return filteredTasks = [Task]()
    }
    
    func sortByDateNewest() -> [Task] {
        filteredTasks.sort { task1, task2 in
            task1.createdDate > task2.createdDate
        }
        return filteredTasks
    }
    
    func sortByDateOldest() -> [Task] {
        filteredTasks.sort { task1, task2 in
            task1.createdDate < task2.createdDate
        }
        return filteredTasks
    }
    
    func sortByTitleAlphabetically() -> [Task] {
        let sortedArray = filteredTasks.filter({ task in
            task.title != nil
        }).sorted (by: { task1, task2 in
            task1.title! < task2.title!
        })
        return sortedArray
    }
    
    func sortByTitleAlphabeticallyInReverseOrder() -> [Task] {
        let sortedArray = filteredTasks.filter({ task in
            task.title != nil
        }).sorted (by: { task1, task2 in
            task1.title! > task2.title!
        })
        return sortedArray
    }
    
    func sortByExecutionDate() -> [Task] {
        filteredTasks.sort { task1, task2 in
            task1.createdDate > task2.createdDate
        }
        return filteredTasks
    }
    
    func sortByComplated() -> [Task] {
        filteredTasks.sort { task1, task2 in
            task1.status && !task2.status
        }
        return filteredTasks
    }
    
    func sortByNotComplated() -> [Task] {
        filteredTasks.sort { task1, task2 in
            task2.status && !task1.status
        }
        return filteredTasks
    }
}
