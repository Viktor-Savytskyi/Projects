//import Mixpanel
//
//enum TrackingEvents {
//	case signUp
//	case login
//	case createPost
//	case updatePost
//	case markedForSale
//	case likePost
//	case buyIt
//	case buyEvent
//	case follow
//	case updateProfile
//	case userProfile
//    case shareItem
//    case shareProfile
//	
//    var title: String {
//        switch self {
//        case .login:
//            return "Login"
//        case .signUp:
//            return "Sign Up"
//        case .createPost:
//            return "Create Post"
//        case .updatePost:
//            return "Update Post"
//        case .markedForSale:
//            return "Mark for sale"
//        case .likePost:
//            return "Like Post"
//        case .buyIt:
//            return "Buy It"
//        case .buyEvent:
//            return "Buy"
//        case .follow:
//            return "Follow"
//        case .updateProfile:
//            return "Update Profile"
//        case .userProfile:
//            return "User Profile"
//        case .shareItem:
//            return "Share Item"
//        case .shareProfile:
//            return "Share Profile"
//        }
//    }
//}
//
//class MixpanelManager {
//    
//    static let shared = MixpanelManager()
//    
//    private init () { }
//	
//	private var applicationToken: String {
//		if BuildManager.shared.buildType == .dev {
//			return "01be9e9e389d22b5ce8372243dd87efa"
//		}
//		return "bb59be2d198b83ad45a316d8058ebf27"
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
