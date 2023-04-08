import Foundation
import UIKit
import FirebaseAuth

enum AuthState {
    case authorized
    case unAuthorized
    case notVerified
}

enum DeepLinkType: CaseIterable {
	case profile, post
	
	var path: String {
		switch self {
		case .profile:
			return "/users/"
		case .post:
			return "/posts/"
		}
	}
}

struct DeepLink {
	var type: DeepLinkType
	var value: String
}

class DeepLinkManager {
	
	static let shared = DeepLinkManager()
	weak var rootNavigationVC: UINavigationController?
	
	private init() { }
    
	func followTheLink(link: DeepLink) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			let authState = AccountManager.shared.authState
			self.openLinkByUserAuthState(link: link, userAuthState: authState)
		}
	}
    
	func getDeepLink(universalUrl: URL) -> DeepLink? {
		for type in DeepLinkType.allCases {
			let split = universalUrl.absoluteString.components(separatedBy: type.path)
			if split.count == 2, let id = split.last {
				return DeepLink(type: type, value: id)
			}
		}
		return nil
    }
    
    func openLinkByUserAuthState(link: DeepLink, userAuthState: AuthState) {
		setRootNavigationViewController(userAuthState: userAuthState)
        switch userAuthState {
        case .authorized:
			switch link.type {
			case .profile:
				openProfilePage(profileId: link.value)
			case .post:
				openPostDetails(postId: link.value)
			}
        case .unAuthorized:
            rootNavigationVC?.pushViewController(RegisterWithEmailViewController(), animated: true)
        case .notVerified:
            break
        }
    }
    
    func setRootNavigationViewController(userAuthState: AuthState) {
        switch userAuthState {
        case .authorized:
            let tabBarVC = Utils.window?.rootViewController as? UITabBarController
            rootNavigationVC = tabBarVC?.viewControllers?[tabBarVC?.selectedIndex ?? 0] as? UINavigationController
        case .unAuthorized:
            rootNavigationVC = Utils.window?.rootViewController as? UINavigationController
        case .notVerified:
            break
        }
    }
 
    func openProfilePage(profileId: String) {
        let profileVC = ProfilePageViewController()
        profileVC.userId = profileId
        rootNavigationVC?.pushViewController(profileVC, animated: true)
    }
    
    func openPostDetails(postId: String) {
        let topVC = rootNavigationVC?.topViewController as? BaseViewController
        topVC?.showLoader()
        FirestoreAPI.shared.getPostById(postId: postId) { post, error in
            topVC?.hideLoader()
            if let error = error {
                topVC?.showMessage(message: error.localizedDescription)
            } else if let post {
				if post.isDeleted {
					topVC?.showMessage(message: "The post has been removed")
					return
				}
                let postDetailsVC = PostDetailsViewController()
                postDetailsVC.post = post
                self.rootNavigationVC?.pushViewController(postDetailsVC, animated: true)
			} else {
				topVC?.showMessage(message: "Invalid post link")
			}
        }
    }
}
