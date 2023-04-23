//
//  CredentialsController.swift
//  Platform
//
//  Created by 12345 on 18.04.2023.
//

import Foundation

class CredentialsController {
    var credentials: CredentialsModel
    
    init(credentials: CredentialsModel) {
        self.credentials = credentials
    }
   
    func validatedEmail() throws {
        guard let email = credentials.email else { return }
        guard email.count > 0 else { throw CredentialsError.requiredField }
        let emailPred = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        if !emailPred.evaluate(with: email) {
            throw CredentialsError.email
        }
    }
    
    func passwordValidated() throws {
        guard let password = credentials.password else { return }
        guard password.count > 0 else { throw CredentialsError.requiredField }
        let range = NSRange(location: 0, length: password.utf16.count)
        let regex = try? NSRegularExpression(pattern: "(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{6,100}")
        if regex?.firstMatch(in: password, options: [], range: range) == nil {
            throw CredentialsError.password
        }
    }
    
    func confirmPasswordValidated() throws {
        guard let password = credentials.password else { return }
        guard let confirmPassword = credentials.confirmPassword else { return }
        if password != confirmPassword {
            throw CredentialsError.confirmPassword
        }
    }
}
