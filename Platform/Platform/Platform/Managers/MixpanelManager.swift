//import Mixpanel

//MARK: use inferitance from String instead of title parameter
//enum TrackingEvents: String {
//	case signUp = "Sign Up"
//	case login = "Login"
//	case createPost = "Create Post"
//	case updatePost = "Update Post"
//	case markedForSale = "Mark for sale"
//	case likePost = "Like Post"
//	case buyIt = "Buy It"
//	case buyEvent = "Buy"
//	case follow = "Follow"
//	case updateProfile = "Update Profile"
//	case userProfile = "User Profile"
//  case shareItem = "Share Item"
//  case shareProfile = "Share Profile"
//}
//
//class MixpanelManager {
//    
//    static let shared = MixpanelManager()
//    
//    private init () { }
//
//MARK: use constant for the key strings
//	private var applicationToken: String {
//		if BuildManager.shared.buildType == .dev {
//            return Constants.MixPanel.devTypeBuild
//		}
//		return Constants.MixPanel.releaseTypeBuild
//	}
//    
//    func setup() {
//        Mixpanel.initialize(token: applicationToken, trackAutomaticEvents: true)
//    }
//	
//	func trackEvent(_ event: TrackingEvents, value: Encodable) {
//		print("mixpanel event - \(event.title) properties - \(value.dictionary as? [String: MixpanelType] ?? [:])")
//		Mixpanel.mainInstance().track(event: event.title, properties: value.dictionary as? [String: MixpanelType] ?? [:])
//		if event == .signUp || event == .login {
//			Mixpanel.mainInstance().identify(distinctId: AccountManager.shared.userId ?? "")
//		}
//	}
//	
//	func setUserProperties(user: CHUser) {
//		Mixpanel.mainInstance().people.set(properties: ["$email": user.email, "$name": user.firstName + " " + user.lastName])
//	}
//}
