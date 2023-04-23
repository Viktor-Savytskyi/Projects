//
//  VerificationViewModel.swift
//  Platform
//
//  Created by 12345 on 23.04.2023.
//

import Foundation
import FirebaseAuth

class VerificationViewModel {
    var timer: Timer!
    
    func setupTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkUserDataUpdate), userInfo: nil, repeats: true)
    }
    
    func cancelTimer() {
        timer.invalidate()
    }
    
    @objc private func checkUserDataUpdate() {
        LoginAPI.shared.updateUserData { error in
            if error == nil, Auth.auth().currentUser?.isEmailVerified ?? false {
                NavigationManager.shared.openInterestsAsRootViewController()
            }
        }
    }
    
    func logOut(completion: ((String) -> Void)?) {
        AccountManager.shared.logout { error in
            completion?(error)
        }
    }
}
