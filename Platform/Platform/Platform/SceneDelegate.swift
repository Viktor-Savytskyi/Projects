import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = LaunchScreenViewController()
        window?.makeKeyAndVisible()
        AccountManager.shared.monitoringAuthState()
		
		guard let userActivity = connectionOptions.userActivities.first,
			  userActivity.activityType == NSUserActivityTypeBrowsingWeb else { return }
		handleUserActivity(userActivity: userActivity)
	}
	
	func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
		handleUserActivity(userActivity: userActivity)
	}
	
    private func handleUserActivity(userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL, let deepLink = DeepLinkManager.shared.getDeepLink(universalUrl: url) {
            DeepLinkManager.shared.followTheLink(link: deepLink)
        }
    }
}
