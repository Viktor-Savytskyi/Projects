//
//  UserInfoError.swift
//  Platform
//
//  Created by 12345 on 21.04.2023.
//

import Foundation

enum UserInfoError: Error {
    case requiredField
    case phone
    case firstName
    case lastName
    case zipCode
    case userName
    
    var description: String {
        switch self {
        case .requiredField:
           return Constants.ErrorTitle.requiredFieldError
        case .phone:
            return Constants.ErrorTitle.phoneNumberError
        case .firstName:
            return Constants.ErrorTitle.firstNameError
        case .lastName:
            return Constants.ErrorTitle.lastNameError
        case .zipCode:
            return Constants.ErrorTitle.zipCodeError
        case .userName:
            return Constants.ErrorTitle.userNameError
        }
    }
}
