//
//  UserInfoValidationDelegate.swift
//  Platform
//
//  Created by 12345 on 21.04.2023.
//

import Foundation

protocol UserInfoValidationDelegate: AnyObject {
    func showPhoneError(error: String?)
    func showFirstNameError(error: String?)
    func showLastNameError(error: String?)
    func showZipCodeError(error: String?)
    func showUserNameError(error: String?)
}
