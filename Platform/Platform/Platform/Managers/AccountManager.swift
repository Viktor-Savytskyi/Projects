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
			let navigationController = UINavigationController()
			if user?.uid == nil {
				let loginViewController = RootLoginViewController()
				navigationController.viewControllers = [loginViewController]
				NotificationsTimer.shared.stopFetchingNotifications()
                self.authState = .unAuthorized
			} else {
				if user?.isEmailVerified ?? false {
                    Utils.window?.rootViewController = self.createTabBar()
					NotificationsTimer.shared.startFetchingNotifications()
                    self.authState = .authorized
					return
				} else {
					let accountVC = CreateAccountViewController()
					navigationController.viewControllers = [accountVC]
                    self.authState = .notVerified
				}
			}
			Utils.window?.rootViewController = navigationController
		}
	}
	
    func createTabBar() -> UITabBarController {
		let tabBar = UITabBarController()
		
		let home = HomeViewController()
		home.tabBarItem = UITabBarItem(
			title: "",
			image: UIImage(named: "home"),
			selectedImage: UIImage(named: "home"))
		
		let createPostVC = CreatePostViewController()
		createPostVC.tabBarItem = UITabBarItem(
			title: "",
			image: UIImage(named: "add"),
			selectedImage: UIImage(named: "add"))
        
        let notificationsVC = NotificationsViewController()
        notificationsVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "notifications"),
            selectedImage: UIImage(named: "notifications")
        )
		
		let account = ProfilePageViewController()
		account.tabBarItem = UITabBarItem(
			title: "",
			image: UIImage(named: "profile"),
			selectedImage: UIImage(named: "profile"))
		
		tabBar.viewControllers = [UINavigationController(rootViewController: home),
								  UINavigationController(rootViewController: createPostVC),
                                  UINavigationController(rootViewController: notificationsVC),
								  UINavigationController(rootViewController: account)]
		tabBar.tabBar.tintColor = .black
        tabBar.tabBar.barTintColor = Constants.Colors.tabBarBackgroundColor
        tabBar.tabBar.backgroundColor = Constants.Colors.tabBarBackgroundColor
		return tabBar
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
