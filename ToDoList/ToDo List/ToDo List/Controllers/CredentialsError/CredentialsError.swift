//
//  CredentialsError.swift
//  ToDo List
//
//  Created by 12345 on 30.11.2021.
//

import Foundation

enum CredentialsError: Error {
    case lowPassword
    case wrongEmail
    case emptyFields
    case wrongCredentials
    
    var description: String {
        switch self {
        case .lowPassword:
            return "Password must be at least 8 symbols"
        case .wrongEmail:
            return "Wrong email format"
        case .emptyFields:
            return "Please fill fields"
        case .wrongCredentials:
            return "Wrong Credentials"
        }
    }
    
}
