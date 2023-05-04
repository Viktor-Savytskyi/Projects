import UIKit
//import FirebaseAuth

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
    
    private let picker = ImagePickerController()
    private var createAccountViewModel: CreateAccountViewModel!
    
    var email: String?
    var password: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        setCreateAccountViewModelCredentials()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		prepareUI()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
	}
    
    override func prepareUI() {
        super.prepareUI()
        privacyPolicyView.prepareLink(navigationController: navigationController)
    }
    
	private func moveToVerificationScreen() {
		let viewController = VerificationViewController()
        viewController.modalPresentationStyle = .overFullScreen
        navigationController?.present(viewController, animated: true)
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
    
    private func setCreateAccountViewModelCredentials() {
        guard let email,
              let password else { return }
        createAccountViewModel = CreateAccountViewModel(email: email, password: password)
        createAccountViewModel.screenLoaderDelegate = self
        createAccountViewModel.showMessageDelegate = self
        createAccountViewModel.userInfoValidationDelegate = self
    }

    private func validate() {
        view.endEditing(true)
        createAccountViewModel.setUserInfoForViewModel(userInfoModel: UserInfoModel(phone: phoneNumberTextFieldView.textField.text!,
                                                                                                   firstName: firstNameTextFieldView.textField.text!,
                                                                                                   lastName: lastNameTextFieldView.textField.text!,
                                                                                                   zipCode: zipCodeTextFieldView.textField.text!,
                                                                                                   userName: userNameTextFieldView.textField.text!))
        createAccountViewModel.validateFiels { [weak self] in
            self?.moveToVerificationScreen()
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

extension CreateAccountViewController: UserInfoValidationDelegate {
    func showPhoneError(error: String?) {
        phoneNumberTextFieldView.errorText = error
    }
    
    func showFirstNameError(error: String?) {
        firstNameTextFieldView.errorText = error
    }
    
    func showLastNameError(error: String?) {
        lastNameTextFieldView.errorText = error
    }
    
    func showZipCodeError(error: String?) {
        zipCodeTextFieldView.errorText = error
    }
    
    func showUserNameError(error: String?) {
        userNameTextFieldView.errorText = error
    }
}

extension CreateAccountViewController: ScreenAlertDelegate {
    func showAlert(error: String, completion: (() -> Void)?) {
        showMessage(message: error)
    }
}

extension CreateAccountViewController: ScreenLoaderDelegate {
    func showScreenLoader() {
        showLoader()
    }
    
    func hideScreenLoader() {
        hideLoader()
    }
}
