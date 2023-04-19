import UIKit
import FirebaseAuth

class AccountManager {
    //MARK: manager should not be responsible for creating the UI
	static let shared = AccountManager()
	
	var currentUser: CHUser?
    var allUsers: [CHUser]?
    var authState: AuthState = .unAuthorized
    weak var screenAlertDelegate: ScreenAlertDelegate?
	
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
            NavigationManager.shared.navigateUserBy(state: self.authState)
		}
	}
	
    func logout(completion: ((String) -> Void)?) {
		do {
            try Auth.auth().signOut()
            AccountManager.shared.currentUser = nil
		} catch let signOutError as NSError {
            completion?("Error signing out: %@ \(signOutError)")
		}
	}
}
