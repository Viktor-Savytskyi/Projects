//
//  UserData.swift
//  Platform
//
//  Created by 12345 on 21.04.2023.
//

import Foundation

struct UserDataModel: Credentials, UserInfo {
    var id: String?
    var email: String?
    var phone: String?
    var firstName: String?
    var lastName: String?
    var zipCode: String?
    var userName: String?
}
