//
//  EmailLoginViewModel.swift
//  Platform
//
//  Created by 12345 on 19.04.2023.
//

import Foundation

class EmailLoginViewModel {
    weak var emailAndPasswordValidationDelegate: EmailAndPasswordValidationDelegate?
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    weak var showMessageDelegate: ScreenAlertDelegate?
    var errorResult = false
    var credentialsController: CredentialsController!
    
    init(email: String, password: String) {
        credentialsController = CredentialsController(credentials: CredentialsModel(email: email,
                                                                                    password: password))
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
            emailAndPasswordValidationDelegate?.showEmailError(error: ((error as? CredentialsError)?.description))
            errorResult = true
        }
    }
    
    private func passwordErrorHendle() {
        do {
            try credentialsController.passwordValidated()
        } catch {
            emailAndPasswordValidationDelegate?.showPasswordError(error: ((error as? CredentialsError)?.description))
            errorResult = true
        }
    }
    
    private func login() {
        screenLoaderDelegate?.showScreenLoader()
        guard let email = credentialsController.credentials.email,
              let password = credentialsController.credentials.password else { return }
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
