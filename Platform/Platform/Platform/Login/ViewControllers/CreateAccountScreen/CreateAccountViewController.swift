import UIKit
import FirebaseAuth

class CreateAccountViewController: BaseViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var mainButton: AppButton!
    @IBOutlet weak var phoneNumberTextFieldView: AppTextFieldView!
    @IBOutlet weak var firstNameTextFieldView: AppTextFieldView!
    @IBOutlet weak var lastNameTextFieldView: AppTextFieldView!
    @IBOutlet weak var zipCodeTextFieldView: AppTextFieldView!
    @IBOutlet weak var userNameTextFieldView: AppTextFieldView!
    @IBOutlet weak var privacyPolicyView: PrivacyPolicyView!
    
    private var textFieldViewsArray = [AppTextFieldView]()
    private var placeholdersArray = [String]()
	private var timer: Timer!
    
    private let picker = ImagePickerController()
    
    var email: String?
    var password: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
		
		if let isVerified = Auth.auth().currentUser?.isEmailVerified, !isVerified {
			showVerificationAlert()
		}
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		prepareUI()
		setupTimer()
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
        cancelTimer()
		navigationController?.setNavigationBarHidden(false, animated: animated)
	}
    
    override func prepareUI() {
        super.prepareUI()
        privacyPolicyView.prepareLink(navigationController: navigationController)
    }
    
	private func showVerificationAlert() {
		let viewController = VerificationViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true)
	}
	
	private func setupTimer() {
		timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkUserDataUpdate), userInfo: nil, repeats: true)
	}
	
	private func cancelTimer() {
		timer.invalidate()
	}
	
	@objc private func checkUserDataUpdate() {
		LoginAPI.shared.updateUserData { error in
			if error == nil, Auth.auth().currentUser?.isEmailVerified ?? false {
				let navigationController = UINavigationController()
				let iterests = InterestsViewController()
				iterests.state = .register
				navigationController.viewControllers = [iterests]
				Utils.window?.rootViewController = navigationController
			}
		}
	}
    
    private func prepareTextFields() {
        textFieldViewsArray = [
            phoneNumberTextFieldView,
            firstNameTextFieldView,
            lastNameTextFieldView,
            zipCodeTextFieldView,
            userNameTextFieldView
        ]
        
        placeholdersArray = [
            "Phone number", "First name", "Last name", "Zip code", "Username"
        ]
        
        phoneNumberTextFieldView.textField.keyboardType = .phonePad
        firstNameTextFieldView.textField.keyboardType = .default
        lastNameTextFieldView.textField.keyboardType = .default
        zipCodeTextFieldView.textField.keyboardType = .numberPad
        userNameTextFieldView.textField.keyboardType = .emailAddress
        firstNameTextFieldView.textField.autocapitalizationType = .words
        lastNameTextFieldView.textField.autocapitalizationType = .words
        firstNameTextFieldView.textField.returnKeyType = .next
        lastNameTextFieldView.textField.returnKeyType = .next
        userNameTextFieldView.textField.returnKeyType = .done
        
        for (index, textFieldView) in textFieldViewsArray.enumerated() {
            textFieldView.placeholder = placeholdersArray[index]
            textFieldView.textField.delegate = self
            textFieldView.textField.tag = index
            textFieldView.errorText = nil
        }
    }

    private func validate() {
        var error = false
        
        let phoneError = Validator.shared.phoneValidated(phoneNumberTextFieldView.textField.text!)
        if phoneError != nil {
            phoneNumberTextFieldView.errorText = phoneError
            error = true
        }
        
        let firstNameError = Validator.shared.firstNameValidated(firstNameTextFieldView.textField.text!)
        if firstNameError != nil {
            firstNameTextFieldView.errorText = firstNameError
            error = true
        }
        
        let lastNameError = Validator.shared.lastNameValidated(lastNameTextFieldView.textField.text!)
        if lastNameError != nil {
            lastNameTextFieldView.errorText = lastNameError
            error = true
        }
        
        let zipCodeError = Validator.shared.zipCodeValidated(zipCodeTextFieldView.textField.text!)
        if zipCodeError != nil {
            zipCodeTextFieldView.errorText = zipCodeError
            error = true
        }
        
        let userNameError = Validator.shared.userNameValidated(userNameTextFieldView.textField.text!)
        if userNameError != nil {
            userNameTextFieldView.errorText = userNameError
            error = true
        }
        view.endEditing(true)
        if !error {
            showLoader()
            FirestoreAPI.shared.checkUserData(localFieldText: userNameTextFieldView.textField.text ?? "", userFieldName: "userName") { [weak self] (isExist, error) in
				guard let self else { return }
                if let error = error {
					self.hideLoader()
                    self.showMessage(message: error.localizedDescription)
                } else if isExist {
					self.hideLoader()
                    self.userNameTextFieldView.errorText = "User name already exist"
                } else {
                    self.registerUser()
                }
            }
        }
    }
    
    private func saveUserData(by id: String) {
        guard let userEmail = email else { return }
        var user: CHUser!
        showLoader()
        
        switch BuildManager.shared.buildType {
        case .release:
            user = CHUser(id: id,
                          email: userEmail,
                          phone: phoneNumberTextFieldView.textField.text!,
                          firstName: firstNameTextFieldView.textField.text!,
                          lastName: lastNameTextFieldView.textField.text!,
                          zipCode: zipCodeTextFieldView.textField.text!,
                          userName: userNameTextFieldView.textField.text!,
                          selectedInterestCodes: AccountManager.shared.currentUser?.selectedInterestCodes ?? [],
                          followedUserIds: [NotificationInfo(userId: Constants.AppOwnerInfo.id)]
            )
        case .dev:
            // without auto subscribing to Choosii owner id
            user = CHUser(id: id,
                          email: userEmail,
                          phone: phoneNumberTextFieldView.textField.text!,
                          firstName: firstNameTextFieldView.textField.text!,
                          lastName: lastNameTextFieldView.textField.text!,
                          zipCode: zipCodeTextFieldView.textField.text!,
                          userName: userNameTextFieldView.textField.text!,
                          selectedInterestCodes: AccountManager.shared.currentUser?.selectedInterestCodes ?? []
            )
        }
        FirestoreAPI.shared.saveUserData(user: user) { [weak self] error in
            guard let self = self else { return }
            self.hideLoader()
            if let error = error {
                self.showMessage(message: error.localizedDescription)
            } else {
//				MixpanelManager.shared.trackEvent(.signUp, value: CHAnalyticUser.initFromUser(user: user))
            }
        }
    }
    
    private func registerUser() {
        guard let userEmail = email, let userPassord = password else { return }
        
        LoginAPI.shared.registerUser(email: userEmail, password: userPassord) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.hideLoader()
                self.showMessage(message: error.localizedDescription)
            } else {
                AccountManager.shared.user?.sendEmailVerification()
                self.saveUserData(by: authResult!.user.uid)
            }
        }
    }
    
    private func clearError() {
        textFieldViewsArray.forEach { textFieldView in
            if textFieldView.textField.isFirstResponder && textFieldView.errorText != nil {
                textFieldView.errorText = nil
            }
        }
    }
    
    @IBAction func mainButtonTapped(_ sender: Any) {
        validate()
    }
}

extension CreateAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextFieldView.textField:
            lastNameTextFieldView.textField.becomeFirstResponder()
        case lastNameTextFieldView.textField:
            zipCodeTextFieldView.textField.becomeFirstResponder()
        default:
            view.endEditing(true)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearError()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        clearError()
        return true
    }
}
