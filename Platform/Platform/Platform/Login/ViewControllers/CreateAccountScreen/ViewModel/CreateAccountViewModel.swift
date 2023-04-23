//
//  CreateAccountViewModel.swift
//  Platform
//
//  Created by 12345 on 21.04.2023.
//

import Foundation
import FirebaseAuth

class CreateAccountViewModel {
    var userInfoController: UserInfoController!
    weak var userInfoValidationDelegate: UserInfoValidationDelegate?
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    weak var showMessageDelegate: ScreenAlertDelegate?
    var errorResult = false
    var email: String
    var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
        
    func setUserInfoForViewModel(userInfoModel: UserInfoModel?) {
        userInfoController = UserInfoController(userInfo: userInfoModel)
    }
    
    private func phoneErrorHandle() {
        do {
            try userInfoController.phoneValidated()
        } catch {
            userInfoValidationDelegate?.showPhoneError(error: getErrorName(error))
            errorResult = true
        }
    }
    
    private func firstNameErrorHandle() {
        do {
            try userInfoController.firstNameValidated()
        } catch {
            userInfoValidationDelegate?.showFirstNameError(error: getErrorName(error))
            errorResult = true
        }
    }
    
    private func lastNameErrorHandle() {
        do {
            try userInfoController.lastNameValidated()
        } catch {
            userInfoValidationDelegate?.showLastNameError(error: getErrorName(error))
            errorResult = true
        }
    }
    
    private func zipCodeErrorHandle() {
        do {
            try userInfoController.zipCodeValidated()
        } catch {
            userInfoValidationDelegate?.showZipCodeError(error: getErrorName(error))
            errorResult = true
        }
    }
    
    private func userNameErrorHandle() {
        do {
            try userInfoController.userNameValidated()
        } catch {
            userInfoValidationDelegate?.showUserNameError(error: getErrorName(error))
            errorResult = true
        }
    }
    
    func validateFiels(completion: (() -> Void)?) {
        phoneErrorHandle()
        firstNameErrorHandle()
        lastNameErrorHandle()
        zipCodeErrorHandle()
        userNameErrorHandle()
        
        if !errorResult {
            checkUserName(completion: completion)
        }
    }
    
    private func checkUserName(completion: (() -> Void)?) {
        screenLoaderDelegate?.showScreenLoader()
        FirestoreAPI.shared.checkUserData(localFieldText: userInfoController.userInfo?.userName ?? "", userFieldName: Constants.Firebase.userIdFieldName) { [weak self] (isExist, error) in
            guard let self else { return }
            if let error = error {
                self.screenLoaderDelegate?.hideScreenLoader()
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else if isExist {
                self.screenLoaderDelegate?.hideScreenLoader()
                self.userInfoValidationDelegate?.showUserNameError(error: Constants.ErrorTitle.userNameAlreadyExist)
            } else {
                self.registerUser(completion: completion)
            }
        }
    }
    
    private func registerUser(completion: (() -> Void)?) {
        LoginAPI.shared.registerUser(email: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.screenLoaderDelegate?.hideScreenLoader()
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
                AccountManager.shared.user?.sendEmailVerification()
                self.saveUserData(by: authResult!.user.uid)
                completion?()
            }
        }
    }
    
    private func saveUserData(by id: String) {
        guard let phone = userInfoController.userInfo?.phone,
              let firstName = userInfoController.userInfo?.firstName,
              let lastName = userInfoController.userInfo?.lastName,
              let zipCode = userInfoController.userInfo?.zipCode,
              let userName = userInfoController.userInfo?.userName else { return }
        var user: CHUser!
        screenLoaderDelegate?.showScreenLoader()
        
        switch BuildManager.shared.buildType {
        case .release:
            user = CHUser(id: id,
                          email: email,
                          phone: phone,
                          firstName: firstName,
                          lastName: lastName,
                          zipCode: zipCode,
                          userName: userName,
                          selectedInterestCodes: AccountManager.shared.currentUser?.selectedInterestCodes ?? [],
                          followedUserIds: [NotificationInfo(userId: Constants.AppOwnerInfo.id)]
            )
        case .dev:
            // without auto subscribing to Choosii owner id
            user = CHUser(id: id,
                          email: email,
                          phone: phone,
                          firstName: firstName,
                          lastName: lastName,
                          zipCode: zipCode,
                          userName: userName,
                          selectedInterestCodes: AccountManager.shared.currentUser?.selectedInterestCodes ?? []
            )
        }
        FirestoreAPI.shared.saveUserData(user: user) { [weak self] error in
            guard let self else { return }
            self.screenLoaderDelegate?.hideScreenLoader()
            if let error = error {
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
                //                MixpanelManager.shared.trackEvent(.signUp, value: CHAnalyticUser.initFromUser(user: user))
            }
        }
    }
    
    private func getErrorName(_ error: Error) -> String? {
        return (error as? UserInfoError)?.description
    }
}
