import Foundation

class Validator {
    
    static let shared = Validator()

    func validatedEmail(_ value: String) -> String? {
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let emailPred = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        if emailPred.evaluate(with: value) {
            return nil
        } else {
            return Constants.ErrorTitle.emailError
        }
    }
    
    func phoneValidated(_ value: String) -> String? {
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        if value.trim().count > Constants.Validator.maxPhoneNumberSymbols || value.trim().count < Constants.Validator.minPhoneNumberSymbols {
            return Constants.ErrorTitle.phoneNumberError
        }
		return nil
        
    }
    
    func firstNameValidated(_ value: String) -> String? {
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
        if count < Constants.Validator.minFirstLastLocationNameSymbols || count > Constants.Validator.maxFirstLastUserNameSymbols {
            return Constants.ErrorTitle.firstNameError
        }
		return nil
    }
    
    func lastNameValidated(_ value: String) -> String? {
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
        if count < Constants.Validator.minFirstLastLocationNameSymbols || count > Constants.Validator.maxFirstLastUserNameSymbols {
            return Constants.ErrorTitle.lastNameError
        }
		return nil
    }
    
    func zipCodeValidated(_ value: String) -> String? {
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        if value.trim().count != Constants.Validator.zipCodeSymbolsCount {
            return Constants.ErrorTitle.zipCodeError
        }
		return nil
    }
    
    func userNameValidated(_ value: String) -> String? {
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
        if count < Constants.Validator.minUserNameSymbols || count > Constants.Validator.maxFirstLastUserNameSymbols {
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
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < Constants.Validator.minFirstLastLocationNameSymbols || count > Constants.Validator.maxLocationSymbols {
            return Constants.ErrorTitle.streetAddressError
        }
		return nil
    }
    
    func cityValidated(_ value: String) -> String? {
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < Constants.Validator.minFirstLastLocationNameSymbols || count > Constants.Validator.maxLocationSymbols {
            return Constants.ErrorTitle.cityError
        }
		return nil
    }
    
    func stateValidated(_ value: String) -> String? {
        //MARK: use constant instead
        guard value.count > 0 else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < Constants.Validator.minFirstLastLocationNameSymbols || count > Constants.Validator.maxLocationSymbols {
            return Constants.ErrorTitle.stateError
        }
		return nil
    }
}
