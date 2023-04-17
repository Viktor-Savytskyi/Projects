import Foundation

enum BuildType {
    case release
    case dev
}

class BuildManager {
    
    static let shared = BuildManager()
    
    private init() { }
    
	var buildType: BuildType {
        guard let buildNumber = Int(Bundle.main.infoDictionary?[Constants.BuildManager.cFBundleVersion] as? String ?? "") else { return .release }
		if buildNumber % 2 == 0 {
			return .release
		} else {
			return .dev
		}
	}
	
	var firebaseConfigFileName: String {
		switch buildType {
		case .release:
            return Bundle.main.path(forResource: Constants.BuildManager.releaseInfoPlistName, ofType: Constants.BuildManager.plistType) ?? ""
		case .dev:
			return Bundle.main.path(forResource: Constants.BuildManager.devInfoPlistName, ofType: Constants.BuildManager.plistType) ?? ""
		}
	}
}
