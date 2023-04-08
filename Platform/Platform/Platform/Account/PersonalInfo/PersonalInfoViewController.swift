import UIKit

class PersonalInfoViewController: BaseViewController {
    
    @IBOutlet weak var firstNameTextFieldView: AppTextFieldView!
    @IBOutlet weak var lastNameTextFieldView: AppTextFieldView!
    @IBOutlet weak var phoneNumberTextFieldView: AppTextFieldView!
    @IBOutlet weak var zipCodeTextFieldView: AppTextFieldView!
    @IBOutlet weak var saveChangesButton: AppButton!
    @IBOutlet weak var cancelButton: AppButton!
    
    private var textFieldViewsArray = [AppTextFieldView]()
    private var placeholdersArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        fetchUserData()
    }
    
    override func prepareUI() {
        super.prepareUI()
        navigationItem.title = "Personal Info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUserData() {
        let currentUser = AccountManager.shared.currentUser
        firstNameTextFieldView.textField.text = currentUser?.firstName
        lastNameTextFieldView.textField.text = currentUser?.lastName
        phoneNumberTextFieldView.textField.text = currentUser?.phone
        zipCodeTextFieldView.textField.text = currentUser?.zipCode
        updateSaveButtonState()
    }
    
	private func fetchUserData() {
		guard let user = AccountManager.shared.user else { return }
		showLoader()
		
		FirestoreAPI.shared.getUserData(userId: user.uid) { [weak self] _, error in
			guard let self = self else { return }
			if let error = error {
				self.hideLoader()
				self.showMessage(message: error.localizedDescription)
			} else {
				self.hideLoader()
				self.setupUserData()
			}
		}
	}
    
    private func prepareTextFields() {
        textFieldViewsArray = [
            firstNameTextFieldView,
            lastNameTextFieldView,
            phoneNumberTextFieldView,
            zipCodeTextFieldView
        ]
        
        placeholdersArray = [
            "First name",
            "Last name",
            "Phone number",
            "Zip code"
        ]
        
        phoneNumberTextFieldView.textField.keyboardType = .phonePad
        firstNameTextFieldView.textField.keyboardType = .default
        lastNameTextFieldView.textField.keyboardType = .default
        zipCodeTextFieldView.textField.keyboardType = .numberPad
        firstNameTextFieldView.textField.autocapitalizationType = .words
        lastNameTextFieldView.textField.autocapitalizationType = .words
        firstNameTextFieldView.textField.returnKeyType = .next
        lastNameTextFieldView.textField.returnKeyType = .next
        
        for (index, textFieldView) in textFieldViewsArray.enumerated() {
            textFieldView.placeholder = placeholdersArray[index]
            textFieldView.errorText = nil
            textFieldView.textField.returnKeyType = .next
            textFieldView.textField.delegate = self
            textFieldView.textField.tag = index
            textFieldView.textField.addTarget(self, action: #selector(updateSaveButtonState), for: .editingChanged)
        }
    }
    
    @objc private func updateSaveButtonState() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        saveChangesButton.isEnabled = !(
            firstNameTextFieldView.textField.text == currentUser.firstName
            && lastNameTextFieldView.textField.text == currentUser.lastName
            && zipCodeTextFieldView.textField.text == currentUser.zipCode
            && phoneNumberTextFieldView.textField.text == currentUser.phone
        )
    }
    
    private func validate() {
        var error = false
        
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
        
        let phoneError = Validator.shared.phoneValidated(phoneNumberTextFieldView.textField.text!)
        if phoneError != nil {
            phoneNumberTextFieldView.errorText = phoneError
            error = true
        }
        
        let zipCodeError = Validator.shared.zipCodeValidated(zipCodeTextFieldView.textField.text!)
        if zipCodeError != nil {
            zipCodeTextFieldView.errorText = zipCodeError
            error = true
        }
        
        view.endEditing(true)
        if !error {
            saveUserDataChanges()
        }
    }
    
    private func saveUserDataChanges() {
        guard let currentUser = AccountManager.shared.currentUser,
              let firstName = firstNameTextFieldView.textField.text,
              let lastName = lastNameTextFieldView.textField.text,
              let phone = phoneNumberTextFieldView.textField.text,
              let zipCode = zipCodeTextFieldView.textField.text else { return }
        currentUser.firstName = firstName
        currentUser.lastName = lastName
        currentUser.phone = phone
        currentUser.zipCode = zipCode
        showLoader()
        FirestoreAPI.shared.saveUserData(user: currentUser) { [weak self] error in
            guard let self = self else { return }
			self.hideLoader()
            if let error = error {
                self.showMessage(message: error.localizedDescription)
            } else {
                self.showToast(message: "Profile updated")
//				MixpanelManager.shared.trackEvent(.updateProfile, value: CHAnalyticUser.initFromUser(user: currentUser))
                self.updateSaveButtonState()
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
    
    @IBAction func saveChangesAction(_ sender: Any) {
        validate()
        view.endEditing(true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        clearError()
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}

extension PersonalInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextFieldView.textField:
            lastNameTextFieldView.textField.becomeFirstResponder()
        case lastNameTextFieldView.textField:
            phoneNumberTextFieldView.textField.becomeFirstResponder()
        default:
            view.endEditing(true)
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        updateSaveButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        clearError()
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        updateSaveButtonState()
        clearError()
        return true
    }
}
