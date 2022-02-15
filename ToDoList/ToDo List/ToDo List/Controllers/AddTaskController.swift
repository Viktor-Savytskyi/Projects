//
//  AddTaskController.swift
//  ToDo List
//
//  Created by 12345 on 04.12.2021.
//

import Foundation
import UIKit

class AddTaskController {
    
    func createTask(name: String?, description: String?, taskDate: Date?) throws -> Task? {
        guard let name = name, let description = description, let date = taskDate else { return nil}

        if name.isEmpty || description.isEmpty {
           throw TaskFillError.emptyFields
        }
        
        let task = Task.init(title: name, description: description, taskDate: date, createdDate: Date(), status: false)
        return task
    }
    
}
