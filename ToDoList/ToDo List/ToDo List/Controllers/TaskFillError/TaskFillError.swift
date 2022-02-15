//
//  TaskError.swift
//  ToDo List
//
//  Created by 12345 on 06.12.2021.
//

import Foundation

enum TaskFillError: Error {
    case emptyFields
    
    var description: String {
        return "Please fill all fields"
    }
}
