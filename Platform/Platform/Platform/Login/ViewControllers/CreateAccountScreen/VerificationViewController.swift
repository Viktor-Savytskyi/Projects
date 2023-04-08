import UIKit

class VerificationViewController: BaseViewController {

    @IBOutlet weak var backButtonImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }
    
    private func addGesture() {
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(moveBack))
        backButtonImage.isUserInteractionEnabled = true
        backButtonImage.addGestureRecognizer(imageViewTapGesture)
    }
    
    @objc private func moveBack() {
        AccountManager.shared.logout()
        dismiss(animated: true)
    }
    
    @IBAction func btnResendClicked(_ sender: Any) {
        showLoader()
        AccountManager.shared.user?.sendEmailVerification(completion: { [weak self] _ in
            self?.hideLoader()
		})
	}
}
