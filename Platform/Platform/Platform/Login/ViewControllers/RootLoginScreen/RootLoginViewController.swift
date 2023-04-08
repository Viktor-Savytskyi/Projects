import UIKit

class RootLoginViewController: BaseViewController {
    
    @IBOutlet private weak var continueWithEmailButton: AppButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var privacyPolicyView: PrivacyPolicyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func prepareUI() {
        super.prepareUI()
        loginButton.setUnderlinedTitle(title: loginButton.currentTitle ?? "Log in")
        privacyPolicyView.prepareLink(navigationController: navigationController)
    }
    
	@IBAction func loginButtonTapped(_ sender: Any) {
		let loginVC = EmailLoginViewController()
		navigationController?.pushViewController(loginVC, animated: true)
	}
	
	@IBAction func continueWithEmailButtonTapped(_ sender: Any) {
        navigationController?.pushViewController(RegisterWithEmailViewController(), animated: true)
    }
}
