import UIKit
import FirebaseAuth

class RegisterWithEmailViewController: BaseViewController {

    @IBOutlet weak var emailTextFieldView: AppTextFieldView!
    @IBOutlet weak var passwordTextFieldView: AppTextFieldView!
    @IBOutlet weak var confirmPasswordTextFieldView: AppTextFieldView!
    @IBOutlet weak var continueButton: AppButton!
    @IBOutlet weak var privacyPolicyView: PrivacyPolicyView!
    
    private var textFieldViewsArray = [AppTextFieldView]()
    private var placeholdersArray = [String]()
    private var registerWithEmailViewModel: RegisterWithEmailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
    }
    
    override func prepareUI() {
        super.prepareUI()
        privacyPolicyView.prepareLink(navigationController: navigationController)
    }

    private func prepareTextFields() {
        textFieldViewsArray = [
            emailTextFieldView,
            passwordTextFieldView,
            confirmPasswordTextFieldView
        ]
        
        placeholdersArray = [
            "Email", "Password", "Confirm password"
        ]
        
        emailTextFieldView.textField.keyboardType = .emailAddress
        passwordTextFieldView.textField.keyboardType = .default
        confirmPasswordTextFieldView.textField.keyboardType = .default
        passwordTextFieldView.textField.isSecureTextEntry = true
        confirmPasswordTextFieldView.textField.isSecureTextEntry = true
        
        for (index, textFieldView) in textFieldViewsArray.enumerated() {
            textFieldView.placeholder = placeholdersArray[index]
            textFieldView.textField.delegate = self
            textFieldView.textField.tag = index
        }
        
        textFieldViewsArray.forEach { $0.errorText = nil }
        textFieldViewsArray.map { $0.textField }.forEach { $0.returnKeyType = .next }
        confirmPasswordTextFieldView.textField.returnKeyType = .done
    }
    
    private func setRegisterWithEmailViewModel() {
        registerWithEmailViewModel = RegisterWithEmailViewModel(email: emailTextFieldView.textField.text!,
                                                                password: passwordTextFieldView.textField.text!,
                                                                confirmPassword: confirmPasswordTextFieldView.textField.text!)
        registerWithEmailViewModel.showMessageDelegate = self
        registerWithEmailViewModel.screenLoaderDelegate = self
        registerWithEmailViewModel.emailAndPasswordValidationDelegate = self
        registerWithEmailViewModel.confirmPasswordValidationDelegate = self
    }
    
    private func validate() {
        setRegisterWithEmailViewModel()
        registerWithEmailViewModel.validateFileds { [weak self] in
            self?.moveToCreateAccountVc()
        }
    }
    
    private func moveToCreateAccountVc() {
        let createAccountViewController = CreateAccountViewController()
        createAccountViewController.email = self.emailTextFieldView.textField.text!
        createAccountViewController.password = self.passwordTextFieldView.textField.text!
        self.navigationController?.pushViewController(createAccountViewController, animated: true)
    }
    
    private func clearError() {
        textFieldViewsArray.forEach { textFieldView in
            if textFieldView.textField.isFirstResponder && textFieldView.errorText != nil {
                textFieldView.errorText = nil
            }
        }
    }

    @IBAction func continueButtonTapped(_ sender: Any) {
        validate()
    }
}

extension RegisterWithEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextFieldView.textField:
            passwordTextFieldView.textField.becomeFirstResponder()
        case passwordTextFieldView.textField:
            confirmPasswordTextFieldView.textField.becomeFirstResponder()
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

extension RegisterWithEmailViewController: EmailAndPasswordValidationDelegate {
    func showEmailError(error: String?) {
        emailTextFieldView.errorText = error
    }
    
    func showPasswordError(error: String?) {
        passwordTextFieldView.errorText = error
    }
}

extension RegisterWithEmailViewController: ConfirmPasswordValidationDelegate {
    func showConfirmPasswordError(error: String?) {
        confirmPasswordTextFieldView.errorText = error
    }
}

extension RegisterWithEmailViewController: ScreenLoaderDelegate {
    func showScreenLoader() {
        showLoader()
    }
    
    func hideScreenLoader() {
        hideLoader()
    }
}

extension RegisterWithEmailViewController: ScreenAlertDelegate {
    func showAlert(error: String, completion: (() -> Void)?) {
        showMessage(message: error)
    }
}
