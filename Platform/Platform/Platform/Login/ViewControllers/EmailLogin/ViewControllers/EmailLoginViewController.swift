import UIKit

class EmailLoginViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logInButton: AppButton!
    @IBOutlet weak var logInwithoutPasswordButton: UIButton!
	@IBOutlet weak var emailAppTextField: AppTextFieldView!
	@IBOutlet weak var passwordAppTextField: AppTextFieldView!
	
	private var textFieldViewsArray = [AppTextFieldView]()
    private var emailValidationViewModel: EmailLoginViewModel!
    
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
    
    private func setEmailLoginViewModel() {
        emailValidationViewModel = EmailLoginViewModel(email: emailAppTextField.textField.text!, password: passwordAppTextField.textField.text!)
        emailValidationViewModel.emailAndPasswordValidationDelegate = self
        emailValidationViewModel.screenLoaderDelegate = self
        emailValidationViewModel.showMessageDelegate = self
    }
    
    private func validate() {
        setEmailLoginViewModel()
        emailValidationViewModel.validateFileds()
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

extension EmailLoginViewController: EmailAndPasswordValidationDelegate {
    func showEmailError(error: String?) {
        emailAppTextField.errorText = error
    }
    
    func showPasswordError(error: String?) {
        passwordAppTextField.errorText = error
    }
}

extension EmailLoginViewController: ScreenLoaderDelegate {
    func showScreenLoader() {
        showLoader()
    }
    
    func hideScreenLoader() {
        hideLoader()
    }
}

extension EmailLoginViewController: ScreenAlertDelegate {
    func showAlert(error: String, completion: (() -> Void)?) {
        showMessage(message: error)
    }
}
