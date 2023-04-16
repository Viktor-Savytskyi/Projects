import Foundation

class Validator {
    
    static let shared = Validator()
    let minFieldSymbols = 0
    let minPhoneNumberSymbols = 6
    let maxPhoneNumberSymbols = 12
    let minFirstLastLocationNameSymbols = 2
    let maxFirstLastUserNameSymbols = 100
    let zipCodeSymbolsCount = 5
    let minUserNameSymbols = 3
    let maxLocationSymbols = 255


    func validatedEmail(_ value: String) -> String? {
        guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if emailPred.evaluate(with: value) {
            return nil
        } else {
            return Constants.ErrorTitle.emailError
        }
    }
    
    func phoneValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
        if value.trim().count > maxPhoneNumberSymbols || value.trim().count < minPhoneNumberSymbols {
            return Constants.ErrorTitle.phoneNumberError
        }
		return nil
        
    }
    
    func firstNameValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
        if count < minFirstLastLocationNameSymbols || count > maxFirstLastUserNameSymbols {
            return Constants.ErrorTitle.firstNameError
        }
		return nil
    }
    
    func lastNameValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
		if count < minFirstLastLocationNameSymbols || count > maxFirstLastUserNameSymbols {
            return Constants.ErrorTitle.lastNameError
        }
		return nil
    }
    
    func zipCodeValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
        if value.trim().count != zipCodeSymbolsCount {
            return Constants.ErrorTitle.zipCodeError
        }
		return nil
    }
    
    func userNameValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
		let count = value.trim().count
		if count < minUserNameSymbols || count > maxFirstLastUserNameSymbols {
            return Constants.ErrorTitle.userNameError
        }
		return nil
    }
    
    func passwordValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
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
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < minFirstLastLocationNameSymbols || count > maxLocationSymbols {
            return Constants.ErrorTitle.streetAddressError
        }
		return nil
    }
    
    func cityValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < minFirstLastLocationNameSymbols || count > maxLocationSymbols {
            return Constants.ErrorTitle.cityError
        }
		return nil
        
    }
    
    func stateValidated(_ value: String) -> String? {
		guard value.count > minFieldSymbols else { return Constants.ErrorTitle.requiredFieldError }
        let count = value.trim().count
        if count < minFirstLastLocationNameSymbols || count > maxLocationSymbols {
            return Constants.ErrorTitle.stateError
        }
		return nil
    }
}
