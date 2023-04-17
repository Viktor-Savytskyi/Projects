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
	
	private init() { }
    
	func followTheLink(link: DeepLink) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			self.openLinkByUserAuthState(link: link, userAuthState: AccountManager.shared.authState)
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
        NavigationManager.shared.setRootNavigationViewController(userAuthState: userAuthState)
        switch userAuthState {
        case .authorized:
			switch link.type {
			case .profile:
                NavigationManager.shared.openProfilePage(profileId: link.value)
			case .post:
                NavigationManager.shared.openPostDetails(postId: link.value,
                                                         isDeletedMessage: Constants.DeepLinkManager.deletedPostMessage,
                                                         invalidLinkMessage: Constants.DeepLinkManager.invalidPostLinkMessage)
			}
        case .unAuthorized:
            NavigationManager.shared.openRegistrationPage()
        case .notVerified:
            break
        }
    }
}
