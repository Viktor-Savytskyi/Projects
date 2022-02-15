//
//  UserSettings.swift
//  TimeApp
//
//  Created by 12345 on 13.11.2021.
//

import Foundation

class UserSettings {
    
    var userIdKey = "userIdKey"
    
    static var shared: UserSettings = {
        let instance = UserSettings()
        return instance
    }()
    
   private init (){}
    
    func setUserID() {
        let userGeneratedID = UUID().uuidString
        UserDefaults.standard.set(userGeneratedID, forKey: userIdKey)
    }
    
    func getUserID() {
        UserDefaults.standard.string(forKey: userIdKey)
    }
    
}
