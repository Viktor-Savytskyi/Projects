import UIKit

class VerificationViewController: BaseViewController {

    @IBOutlet weak var backButtonImage: UIImageView!
    
    var verificationViewModel = VerificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verificationViewModel.setupTimer()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        verificationViewModel.cancelTimer()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func addGesture() {
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveBack))
        backButtonImage.isUserInteractionEnabled = true
        backButtonImage.addGestureRecognizer(imageViewTapGesture)
    }
    
    @objc private func moveBack() {
        verificationViewModel.logOut { [weak self] error in
            self?.showMessage(message: error)
        }
    }
    
    @IBAction func btnResendClicked(_ sender: Any) {
        showLoader()
        AccountManager.shared.user?.sendEmailVerification(completion: { [weak self] _ in
            self?.hideLoader()
		})
	}
}
