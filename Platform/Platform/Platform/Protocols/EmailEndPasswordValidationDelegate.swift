//
//  EmailEndPasswordValidationDelegate.swift
//  Platform
//
//  Created by 12345 on 20.04.2023.
//

import Foundation

protocol EmailAndPasswordValidationDelegate: AnyObject {
    func showEmailError(error: String?)
    func showPasswordError(error: String?)
}

protocol ConfirmPasswordValidationDelegate: AnyObject {
    func showConfirmPasswordError(error: String?)
}
