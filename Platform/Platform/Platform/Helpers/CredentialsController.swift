//
//  CredentialsController.swift
//  Platform
//
//  Created by 12345 on 18.04.2023.
//

import Foundation

struct Credentials {
    var email: String?
    var password: String?
    var confirmPassword: String?
}

enum CredentialsError: Error {
    case requiredFieldError
    case emailError
    case passwordError
    case confirmPasswordError
    
    var description: String {
        switch self {
        case .requiredFieldError:
           return Constants.ErrorTitle.requiredFieldError
        case .emailError:
            return Constants.ErrorTitle.emailError
        case .passwordError:
            return Constants.ErrorTitle.passwordError
        case .confirmPasswordError:
            return Constants.ErrorTitle.confirmPasswordError
        }
    }
}

//MARK: - Maby create custom credentials controller instead of validate func inside many classes
class CredentialsController {
    var credentials: Credentials
    
    init(credentials: Credentials) {
        self.credentials = credentials
    }
   
    func validatedEmail() throws {
        guard let email = credentials.email else { return }
        guard email.count > 0 else { throw CredentialsError.requiredFieldError }
        let emailPred = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        if !emailPred.evaluate(with: email) {
            throw CredentialsError.emailError
        }
    }
    
    func passwordValidated() throws {
        guard let password = credentials.password else { return }
        guard password.count > 0 else { throw CredentialsError.requiredFieldError }
        let range = NSRange(location: 0, length: password.utf16.count)
        let regex = try? NSRegularExpression(pattern: "(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{6,100}")
        if regex?.firstMatch(in: password, options: [], range: range) == nil {
            throw CredentialsError.passwordError
        }
    }
    
    func confirmPasswordValidated() throws {
        guard let password = credentials.password else { return }
        guard let confirmPassword = credentials.confirmPassword else { return }
        if password != confirmPassword {
            throw CredentialsError.confirmPasswordError
        }
    }
}
