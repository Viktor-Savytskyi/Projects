//
//  UserSettings.swift
//  ImageApp
//
//  Created by 12345 on 29.09.2021.
//

import Foundation

class UserSettings {
    
    var userIdKey = "userIdKey"
    
    static var shared: UserSettings = {
        let instanse = UserSettings()
        return instanse
    }()
    
    private init () {}
    
    func setUserId(){
        let userIdGenereted = UUID().uuidString
        UserDefaults.standard.set(userIdGenereted, forKey: userIdKey)
    }
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }
}



