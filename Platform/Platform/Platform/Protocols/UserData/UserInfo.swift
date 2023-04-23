//
//  UserInfo.swift
//  Platform
//
//  Created by 12345 on 21.04.2023.
//

import Foundation

protocol UserInfo {
    var phone: String? { get set }
    var firstName: String? { get set }
    var lastName: String? { get set }
    var zipCode: String? { get set }
    var userName: String? { get set }
}
