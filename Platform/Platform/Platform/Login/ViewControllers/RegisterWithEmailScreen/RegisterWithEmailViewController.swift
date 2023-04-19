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
  
    private func checkExistingEmail() {
        showLoader()
        FirestoreAPI.shared.checkUserData(localFieldText: emailTextFieldView.textField.text!, userFieldName: "email") { [weak self] (isExist, fbError) in
            guard let self else { return }
            self.hideLoader()
            if let fbError {
                self.showToast(message: fbError.localizedDescription)
            } else if isExist {
                self.emailTextFieldView.errorText = Constants.ErrorTitle.emailExistError
            } else {
                self.moveToCreateAccountVc()
            }
        }
    }
    
    private func validate() {
        var error = false

        let emailError = Validator.shared.validatedEmail(emailTextFieldView.textField.text!)
        if emailError != nil {
            emailTextFieldView.errorText = emailError
            error = true
        }

        let passwordError = Validator.shared.passwordValidated(passwordTextFieldView.textField.text!)
        if passwordError != nil {
            passwordTextFieldView.errorText = passwordError
            error = true
        }

        let confirmPasswordError = Validator.shared.confirmPasswordValidated(passwordTextFieldView.textField.text!, confirmPasswordTextFieldView.textField.text!)
        if confirmPasswordError != nil {
            confirmPasswordTextFieldView.errorText = confirmPasswordError
            error = true
        }
        
        if !error {
            checkExistingEmail()
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
        if let nextField = textField.superview?.superview?.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
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
