import UIKit

class BaseViewController: UIViewController {
	
	private let child: SpinnerViewController = SpinnerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigationVisible()
    }
    
    func prepareUI() {
        view.backgroundColor = Constants.Colors.background
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        let backImage = UIImage(named: "back")
        navigationController?.navigationBar.backIndicatorImage = backImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationController?.navigationBar.tintColor = Constants.Colors.textOnLight
        navigationController?.navigationBar.barTintColor = Constants.Colors.textOnLight
        
        navigationItem.hidesBackButton = (navigationController?.viewControllers.count ?? 0) <= 1
    }
	
    func createCustomViewForBarButton(imageName: String, action: Selector) -> UIView {
        let buttonImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        buttonImageView.image = UIImage(named: imageName)
        let barButtontView = UIView(frame: buttonImageView.frame)
        barButtontView.addSubview(buttonImageView)
        let buttonGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
        barButtontView.addGestureRecognizer(buttonGestureRecognizer)
        return barButtontView
	}
    
    func showAllowAccessToCameraAlert() {
        DispatchQueue.main.async { [self] in
            let alert = UIAlertController(
                title: "Please Allow Access",
                message: "Access to the camera has been prohibited; please enable it in the Settings app to continue.",
                preferredStyle: .alert
            )
            
            alert.addAction(.init(title: "Settings", style: .default, handler: { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }))
            
            alert.addAction(.init(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
	
	func showLoader() {
		addChild(child)
		child.view.frame = UIScreen.main.bounds
		view.addSubview(child.view)
		child.didMove(toParent: self)
	}
    
	func hideLoader() {
		child.willMove(toParent: nil)
		child.view.removeFromSuperview()
		child.removeFromParent()
	}
}
