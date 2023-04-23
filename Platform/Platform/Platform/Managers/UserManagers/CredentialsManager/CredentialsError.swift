//
//  CredentialsError.swift
//  Platform
//
//  Created by 12345 on 21.04.2023.
//

import Foundation

enum CredentialsError: Error {
    case requiredField
    case email
    case password
    case confirmPassword
    
    var description: String {
        switch self {
        case .requiredField:
           return Constants.ErrorTitle.requiredFieldError
        case .email:
            return Constants.ErrorTitle.emailError
        case .password:
            return Constants.ErrorTitle.passwordError
        case .confirmPassword:
            return Constants.ErrorTitle.confirmPasswordError
        }
    }
}
