import UIKit

class Utils {
	class var window: UIWindow? {
		guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
			  let delegate = windowScene.delegate as? SceneDelegate, let window = delegate.window else { return nil }
		return window
	}
}
