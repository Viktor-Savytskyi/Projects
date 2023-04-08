import UIKit

class ShippingInfoViewController: BaseViewController {
    
    @IBOutlet weak var streetAddressTextFieldView: AppTextFieldView!
    @IBOutlet weak var aptSuiteOtherTextFieldView: AppTextFieldView!
    @IBOutlet weak var cityTextFieldView: AppTextFieldView!
    @IBOutlet weak var stateTextFieldView: AppTextFieldView!
    @IBOutlet weak var zipCodeTextFieldView: AppTextFieldView!
    @IBOutlet weak var saveChangesButton: AppButton!
    
    private var textFieldViewsArray = [AppTextFieldView]()
    private var placeholdersArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTextFields()
        fetchUserData()
    }
    
    override func prepareUI() {
        super.prepareUI()
        navigationItem.title = "Shipping Info"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func prepareTextFields() {
        textFieldViewsArray = [
            streetAddressTextFieldView,
            aptSuiteOtherTextFieldView,
            cityTextFieldView,
            stateTextFieldView,
            zipCodeTextFieldView
        ]
        
        placeholdersArray = [
            "Street Address", "Apt / Suite / Other (optional)", "City", "State", "Zip Code"
        ]
        
        for (index, textFieldView) in textFieldViewsArray.enumerated() {
            textFieldView.placeholder = placeholdersArray[index]
            textFieldView.errorText = nil
            textFieldView.textField.returnKeyType = .next
            textFieldView.textField.autocapitalizationType = .words
            textFieldView.textField.delegate = self
            textFieldView.textField.tag = index
            textFieldView.textField.addTarget(self, action: #selector(updateSaveButtonState), for: .editingChanged)
            if textFieldView == zipCodeTextFieldView {
                textFieldView.textField.keyboardType = .numberPad
            }
        }
    }
    
    private func setupUserData() {
        let currentUser = AccountManager.shared.currentUser
        streetAddressTextFieldView.textField.text = currentUser?.shippingInfo?.streetAddress
        aptSuiteOtherTextFieldView.textField.text = currentUser?.shippingInfo?.aptSuiteOther
        cityTextFieldView.textField.text = currentUser?.shippingInfo?.city
        stateTextFieldView.textField.text = currentUser?.shippingInfo?.state
        zipCodeTextFieldView.textField.text = currentUser?.shippingInfo?.shippingZipCode
        updateSaveButtonState()
    }
    
    @objc private func updateSaveButtonState() {
        guard let currentUser = AccountManager.shared.currentUser else { return }
        saveChangesButton.isEnabled = !(
            streetAddressTextFieldView.textField.text == currentUser.shippingInfo?.streetAddress
            && aptSuiteOtherTextFieldView.textField.text == currentUser.shippingInfo?.aptSuiteOther
            && cityTextFieldView.textField.text == currentUser.shippingInfo?.city
            && stateTextFieldView.textField.text == currentUser.shippingInfo?.state
            && zipCodeTextFieldView.textField.text == currentUser.shippingInfo?.shippingZipCode
        )
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
    
    private func validate() {
        var error = false
        
        let streetsAddressError = Validator.shared.streetAddressValidated(streetAddressTextFieldView.textField.text!)
        if streetsAddressError != nil {
            streetAddressTextFieldView.errorText = streetsAddressError
            error = true
        }
        
        let cityError = Validator.shared.cityValidated(cityTextFieldView.textField.text!)
        if cityError != nil {
            cityTextFieldView.errorText = cityError
            error = true
        }
        
        let stateError = Validator.shared.stateValidated(stateTextFieldView.textField.text!)
        if stateError != nil {
            stateTextFieldView.errorText = stateError
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
        guard let currentUser = AccountManager.shared.currentUser else { return }
        guard let streetAddress = streetAddressTextFieldView.textField.text,
              let aptSuiteOther = aptSuiteOtherTextFieldView.textField.text,
              let city = cityTextFieldView.textField.text,
              let state = stateTextFieldView.textField.text,
              let shippingZipCode = zipCodeTextFieldView.textField.text else { return }
        currentUser.shippingInfo = UserShippingInfo(streetAddress: streetAddress, aptSuiteOther: aptSuiteOther, city: city, state: state, shippingZipCode: shippingZipCode)
        showLoader()
        FirestoreAPI.shared.saveUserData(user: currentUser) { [weak self] error in
            guard let self = self else { return }
            self.hideLoader()
            if let error = error {
                self.showMessage(message: error.localizedDescription)
            } else {
                self.showToast(message: "Shipping Info updated")
//				MixpanelManager.shared.trackEvent(.updateProfile, value: currentUser.shippingInfo)
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

extension ShippingInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case streetAddressTextFieldView.textField:
            aptSuiteOtherTextFieldView.textField.becomeFirstResponder()
        case aptSuiteOtherTextFieldView.textField:
            cityTextFieldView.textField.becomeFirstResponder()
        case cityTextFieldView.textField:
            stateTextFieldView.textField.becomeFirstResponder()
        case stateTextFieldView.textField:
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
