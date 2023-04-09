import UIKit
import FirebaseAuth

class AccountManager {
	
	static let shared = AccountManager()
	
	var currentUser: CHUser?
    var allUsers: [CHUser]?
    var authState: AuthState = .unAuthorized
	
	var user: User? {
		return Auth.auth().currentUser
	}
	
	var userId: String? {
		return user?.uid
	}
	
	var shouldUpdateHomeScreenOnAppear: Bool = false
	
	private init() { }
	
    func monitoringAuthState() {
		Auth.auth().addStateDidChangeListener { _, user in
			if user?.uid == nil {
				NotificationsTimer.shared.stopFetchingNotifications()
                self.authState = .unAuthorized
			} else {
				if user?.isEmailVerified ?? false {
					NotificationsTimer.shared.startFetchingNotifications()
                    self.authState = .authorized
				} else {
                    self.authState = .notVerified
				}
			}
            NavigationBuilder.shared.navigateUserBy(state: self.authState)
		}
	}
	
	func logout() {
		do {
            try Auth.auth().signOut()
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
		}
        AccountManager.shared.currentUser = nil
	}
}
