import Foundation

class Validator {
    
    static let shared = Validator()
    
    func validatedEmail(_ value: String) -> String? {
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: value) {
            return nil
        } else {
            return Constants.ErrorTitle.emailError
        }
    }
    
    func phoneValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        if value.trim().count > 12 || value.trim().count < 6 {
            return Constants.ErrorTitle.phoneNumberError
        }
		return nil
        
    }
    
    func firstNameValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
        if count < 2 || count > 100 {
            return Constants.ErrorTitle.firstNameError
        }
		return nil
    }
    
    func lastNameValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
		if count < 2 || count > 100 {
            return Constants.ErrorTitle.lastNameError
        }
		return nil
    }
    
    func zipCodeValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        if value.trim().count != 5 {
            return Constants.ErrorTitle.zipCodeError
        }
		return nil
    }
    
    func userNameValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
		if count < 3 || count > 100 {
            return Constants.ErrorTitle.userNameError
        }
		return nil
    }
    
    func passwordValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let range = NSRange(location: 0, length: value.utf16.count)
        let regex = try? NSRegularExpression(pattern: "(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{6,100}")
        if regex?.firstMatch(in: value, options: [], range: range) != nil {
            return nil
        } else {
            return Constants.ErrorTitle.passwordError
        }
    }
    
    func confirmPasswordValidated(_ password: String, _ confirmPassword: String) -> String? {
        if password != confirmPassword {
            return Constants.ErrorTitle.confirmPasswordError
        }
		return nil
    }
    
    func streetAddressValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < 2 || count > 255 {
            return Constants.ErrorTitle.streetAddressError
        }
		return nil
    }
    
    func cityValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < 2 || count > 255 {
            return Constants.ErrorTitle.cityError
        }
		return nil
        
    }
    
    func stateValidated(_ value: String) -> String? {
		guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < 2 || count > 255 {
            return Constants.ErrorTitle.stateError
        }
		return nil
    }
}
