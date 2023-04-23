//
//  EmailLoginViewModel.swift
//  Platform
//
//  Created by 12345 on 19.04.2023.
//

import Foundation

class EmailLoginViewModel {
    var credentials: CredentialsModel
    weak var emailAndPasswordValidationDelegate: EmailAndPasswordValidationDelegate?
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    weak var showMessageDelegate: ScreenAlertDelegate?
    var errorResult = false
    var credentialsController: CredentialsController!
    
    init(credentials: CredentialsModel) {
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
