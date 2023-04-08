import UIKit

class EmailLoginViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var emailOrUserNameReuseView: AppTextFieldView!
    @IBOutlet weak var passwordReusebleView: AppTextFieldView!
    @IBOutlet weak var logInButton: AppButton!
    @IBOutlet weak var logInwithoutPasswordButton: UIButton!
	@IBOutlet weak var emailAppTextField: AppTextFieldView!
	@IBOutlet weak var passwordAppTextField: AppTextFieldView!
	
	private var textFieldViewsArray = [AppTextFieldView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		prepareTextFields()
		textFieldViewsArray = [emailAppTextField, passwordAppTextField]
		
    }
    
    private func prepareTextFields() {
        emailAppTextField.placeholder = "Email"
        passwordAppTextField.placeholder = "Password"
        emailAppTextField.textField.delegate = self
        passwordAppTextField.textField.delegate = self
        passwordAppTextField.textField.isSecureTextEntry = true
        emailAppTextField.textField.keyboardType = .emailAddress
    }
    
    private func validate() {
        var error = false
        
        let emailError = Validator.shared.validatedEmail(emailOrUserNameReuseView.textField.text!)
        if emailError != nil {
            emailOrUserNameReuseView.errorText = emailError
            error = true
        }
        
        let passwordError = Validator.shared.passwordValidated(passwordReusebleView.textField.text!)
        if passwordError != nil {
            passwordReusebleView.errorText = passwordError
            error = true
        }
        
        if !error {
            login()
        }
    }
    
    private func login() {
		showLoader()
		let emailText = emailAppTextField.textField.text!.trim()
		LoginAPI.shared.login(email: emailText, password: passwordAppTextField.textField.text!) { [weak self] _, error in
			self?.hideLoader()
            if let error = error {
                self?.showMessage(message: error.localizedDescription)
			} else {
//				MixpanelManager.shared.trackEvent(.login, value: LoginModel(email: emailText))
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
    
	@IBAction func loginButtonClicked(_ sender: Any) {
        validate()
	}
}

extension EmailLoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearError()
	}
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		clearError()
		return true
	}
}
