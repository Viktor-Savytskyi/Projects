//
//  RegisterWithEmailViewModel.swift
//  Platform
//
//  Created by 12345 on 20.04.2023.
//

import Foundation

class RegisterWithEmailViewModel {
    var email: String?
    weak var emailAndPasswordValidationDelegate: EmailAndPasswordValidationDelegate?
    weak var confirmPasswordValidationDelegate: ConfirmPasswordValidationDelegate?
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    weak var showMessageDelegate: ScreenAlertDelegate?
    var errorResult = false
    var credentialsController: CredentialsController!
    var moveToAccountVcCompletion: (() -> Void)?
    
    init(email: String, password: String, confirmPassword: String) {
        credentialsController = CredentialsController(credentials: CredentialsModel(email: email, password: password, confirmPassword: confirmPassword))
        self.email = credentialsController.credentials.email

    }
    
    func validateFileds(completion: (() -> Void)?) {
        emailErrorHendle()
        passwordErrorHendle()
        confirmPasswordErrorHendle()
        if !errorResult {
            checkExistingEmail(completion: completion)
        }
    }
    
    private func emailErrorHendle() {
        do {
            try credentialsController.validatedEmail()
        } catch {
            emailAndPasswordValidationDelegate?.showEmailError(error: getError(error))
            errorResult = true
        }
    }
    
    private func passwordErrorHendle() {
        do {
            try credentialsController.passwordValidated()
        } catch {
            emailAndPasswordValidationDelegate?.showPasswordError(error: getError(error))
            errorResult = true
        }
    }
    
    private func confirmPasswordErrorHendle() {
        do {
            try credentialsController.confirmPasswordValidated()
        } catch {
            confirmPasswordValidationDelegate?.showConfirmPasswordError(error: getError(error))
            errorResult = true
        }
    }
    
    private func getError(_ error: Error) -> String? {
        return (error as? CredentialsError)?.description
    }
    
    private func checkExistingEmail(completion: (() -> Void)?) {
        guard let email else { return }
        screenLoaderDelegate?.showScreenLoader()
        FirestoreAPI.shared.checkUserData(localFieldText: email, userFieldName: Constants.Firebase.emailFieldName) { [weak self] (isExist, fbError) in
            guard let self else { return }
            self.screenLoaderDelegate?.hideScreenLoader()
            if let fbError {
                self.showMessageDelegate?.showAlert(error: fbError.localizedDescription, completion: nil)
            } else if isExist {
                self.emailAndPasswordValidationDelegate?.showEmailError(error: Constants.ErrorTitle.emailExistError)
            } else {
                completion?()
            }
        }
    }
}
