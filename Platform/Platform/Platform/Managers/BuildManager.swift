import Foundation

enum BuildType {
    case release
    case dev
}

class BuildManager {
    
    static let shared = BuildManager()
    
	var buildType: BuildType {
		guard let buildNumber = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "") else { return .release }
		if buildNumber % 2 == 0 {
			return .release
		} else {
			return .dev
		}
	}
	
	var firebaseConfigFileName: String {
		switch buildType {
		case .release: // GoogleService-Prod-Info      old GoogleService-Info
			return Bundle.main.path(forResource: "GoogleService-Prod-Info", ofType: "plist") ?? ""
		case .dev: // GoogleService-Dev-Info       old GoogleService-Info-Dev
			return Bundle.main.path(forResource: "GoogleService-Dev-Info", ofType: "plist") ?? ""
		}
	}
    
   private init() { }
}
