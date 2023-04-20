//
//  EmailLoginViewModel.swift
//  Platform
//
//  Created by 12345 on 19.04.2023.
//

import Foundation

protocol LoginValidationDelegate: AnyObject {
    func showEmailError(error: String?)
    func showPasswordError(error: String?)
}

class EmailLoginViewModel {
    var credentials: Credentials
    weak var loginValidationDelegate: LoginValidationDelegate?
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    var showMessageDelegate: ScreenAlertDelegate?
    var errorResult = false
    var credentialsController: CredentialsController!
    
    init(credentials: Credentials) {
        self.credentials = credentials
        credentialsController = CredentialsController(credentials: credentials)
    }
    
    func validateFileds() {
        emailErrorHendle()
        passwordErrorHendle()

        if !errorResult {
            login()
        }
    }
    
    private func emailErrorHendle() {
        do {
            try credentialsController.validatedEmail()
        } catch {
            loginValidationDelegate?.showEmailError(error: ((error as? CredentialsError)?.description))
            errorResult = true
        }
    }
    
    private func passwordErrorHendle() {
        do {
            try credentialsController.passwordValidated()
        } catch {
            loginValidationDelegate?.showPasswordError(error: ((error as? CredentialsError)?.description))
            errorResult = true
        }
    }
    
    private func login() {
        screenLoaderDelegate?.showScreenLoader()
        guard let email = credentials.email,
              let password = credentials.password else { return }
        let emailText = email.trim()
        LoginAPI.shared.login(email: emailText, password: password) {[weak self] _, error in
            self?.screenLoaderDelegate?.hideScreenLoader()
            if let error = error {
                self?.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
//                MixpanelManager.shared.trackEvent(.login, value: LoginModel(email: emailText))
            }
        }
    }

}
