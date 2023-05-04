//
//  UserInfoController.swift
//  Platform
//
//  Created by 12345 on 21.04.2023.
//

import Foundation

class UserInfoController {
    var userInfo: UserInfoModel?
    
    init(userInfo: UserInfoModel?) {
        self.userInfo = userInfo
    }
    
    func phoneValidated() throws {
        // MARK: use constant instead
        guard let userInfo,
              let value = userInfo.phone else { return }
        guard value.count > 0 else { throw UserInfoError.requiredField }
        if value.trim().count > Constants.Validator.maxPhoneNumberSymbols || value.trim().count < Constants.Validator.minPhoneNumberSymbols {
            throw UserInfoError.phone
        }
    }
    
    func firstNameValidated() throws {
        // MARK: use constant instead
        guard let userInfo,
              let value = userInfo.firstName else { return }
        guard value.count > 0 else { throw UserInfoError.requiredField }
        let count = value.trim().count
        if count < Constants.Validator.minFirstLastLocationNameSymbols || count > Constants.Validator.maxFirstLastUserNameSymbols {
            throw UserInfoError.firstName
        }
    }
    
    func lastNameValidated() throws {
        // MARK: use constant instead
        guard let userInfo,
              let value = userInfo.lastName else { return }
        guard value.count > 0 else { throw UserInfoError.requiredField }
        let count = value.trim().count
        if count < Constants.Validator.minFirstLastLocationNameSymbols || count > Constants.Validator.maxFirstLastUserNameSymbols {
            throw UserInfoError.lastName
        }
    }
    
    func zipCodeValidated() throws {
        // MARK: use constant instead
        guard let userInfo,
              let value = userInfo.zipCode else { return }
        guard value.count > 0 else { throw UserInfoError.requiredField }
        if value.trim().count != Constants.Validator.zipCodeSymbolsCount {
            throw UserInfoError.zipCode
        }
    }
    
    func userNameValidated() throws {
        // MARK: use constant instead
        guard let userInfo,
              let value = userInfo.userName else { return }
        guard value.count > 0 else { throw UserInfoError.requiredField }
        let count = value.trim().count
        if count < Constants.Validator.minUserNameSymbols || count > Constants.Validator.maxFirstLastUserNameSymbols {
            throw UserInfoError.userName
        }
    }
}
