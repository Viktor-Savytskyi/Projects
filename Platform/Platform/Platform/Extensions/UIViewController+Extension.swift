import UIKit

extension UIViewController {
    
	func showMessage(title: String = "Error", message: String, handler: ((UIAlertAction) -> Void)? = nil ) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
		self.present(alert, animated: true, completion: nil)
	}
	
	func showToast(message: String, seconds: Double = 1) {
		let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		alert.view.alpha = 0.6
		alert.view.layer.cornerRadius = 15

		present(alert, animated: true)

		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
			alert.dismiss(animated: true)
		}
	}
     
    func setNavigationVisible(tabBarIsHidden: Bool = false, navigationBarIsHidden: Bool = false) {
        navigationController?.navigationBar.isHidden = navigationBarIsHidden
        tabBarController?.tabBar.isHidden = tabBarIsHidden
    }
    
    func setNavigationBarLargeTitle() {
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.Colors.textOnLight,
            .font: UIFont.navigationBarTitle ?? .systemFont(ofSize: 35)
        ]
    }
    
    func removeNavigationBarLargeTitle() {
        navigationController?.navigationBar.titleTextAttributes = nil
    }
    
    func share(deepLink: DeepLink) {        
		var hostUrl = ""
		switch BuildManager.shared.buildType {
		case .release:
			hostUrl = Constants.URLs.productionServerUrl
		case .dev:
			hostUrl = Constants.URLs.devServerUrl
		}
		let url = NSURL(string: "\(hostUrl)\(deepLink.type.path)\(deepLink.value)")
        let activityViewController = UIActivityViewController(activityItems: [url ?? ""], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.permittedArrowDirections = []
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.midX, y: view.frame.midY, width: 0, height: 0)
        present(activityViewController, animated: true, completion: nil)
    }
    
    enum ObjectTypeToShare: String {
        case post, profile
    }
}
