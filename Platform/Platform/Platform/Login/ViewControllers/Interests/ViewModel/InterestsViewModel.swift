//
//  InterestsViewModel.swift
//  Platform
//
//  Created by 12345 on 24.04.2023.
//

import Foundation
import FirebaseAuth

class InterestsViewModel {
    private let interestManager = InterestManager.shared
    private let imageUploadManager = ImageUploadManager.shared
    weak var updateInterestsScreenDelegate: UpdateInterestsScreenDelegate?
    weak var screenLoaderDelegate: ScreenLoaderDelegate?
    weak var showMessageDelegate: ScreenAlertDelegate?
    weak var showToastDelegate: ScreenToastDelegate?
    private var filteredInterestsResponse: InterestResponse?
    
    func searchCategory(text: String, completion: (() -> Void)?) {
        guard let categoriesForSearch = interestManager.interestsTree else { return }
        filteredInterestsResponse = categoriesForSearch
        filteredInterestsResponse?.categories = []
        
        if !text.isEmpty {
            categoriesForSearch.categories.forEach { category in
                if category.code.lowercased().contains(text.lowercased()) {
                    filteredInterestsResponse?.categories.append(category)
                } else if let machingCategories = category.children?.filter({ $0.code.lowercased().contains(text.lowercased()) }), !machingCategories.isEmpty {
                    filteredInterestsResponse?.categories.append(Category(code: category.code, children: machingCategories))
                }
            }
        } else {
            filteredInterestsResponse = nil
        }
        completion?()
    }
    
    func setupUserInterests() {
        interestManager.customInterestsTree = nil
        getInterests()
        loadSelectedInterests()
    }
    
    func getFilteredInterestsResponse() -> InterestResponse? {
        filteredInterestsResponse
    }
    
    func getFilteredInterestsResponseCategories() -> [Category]? {
        filteredInterestsResponse?.categories
    }
    
    func getInterestsTree() -> InterestResponse? {
        interestManager.interestsTree
    }
    
    func getInterestTreeCategories() -> [Category] {
        interestManager.interestsTree!.categories
    }
    
    func moveToHomeScreen() {
        NavigationManager.shared.navigateUserBy(state: .authorized)
    }
    
    func switchSelection(item: Category) {
        interestManager.switchSelection(item: item)
    }
    
    func loadSelectedInterests() {
        screenLoaderDelegate?.showScreenLoader()
        FirestoreAPI.shared.getUserData(userId: Auth.auth().currentUser?.uid ?? "") { [weak self] (user, error) in
            guard let self else { return }
            if let error = error {
                self.screenLoaderDelegate?.hideScreenLoader()
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
                self.interestManager.selectedCodes = user?.selectedInterestCodes ?? []
                self.updateInterestsScreenDelegate?.updateScreen()
            }
        }
    }
    
    func getInterests() {
        screenLoaderDelegate?.showScreenLoader()
        FirestoreAPI.shared.getInterests { [weak self] response, error in
            guard let self else { return }
            self.screenLoaderDelegate?.hideScreenLoader()
            if let error = error {
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
                if AccountManager.shared.currentUser?.customTree == nil {
                    self.interestManager.interestsTree = response
                } else {
                    self.interestManager.customInterestsTree = AccountManager.shared.currentUser?.customTree
                    self.interestManager.interestsTree = self.interestManager.customInterestsTree
                }
                self.updateInterestsScreenDelegate?.updateScreen()
            }
        }
    }
    
    func setupImageUploadManagerDelegates(_ viewController: BaseViewController) {
        imageUploadManager.setupDelegates(viewController)
    }
    
    func createPost(post: Post,
                    editLocalImageFirst: LocalImage?,
                    editLocalImageSecond: LocalImage?,
                    editLocalImageThird: LocalImage?, completion: (() -> Void)?) {
        post.interestCodes = interestManager.selectedCodes
        post.updatedAt = Date()
        imageUploadManager.uploadImages(post: post,
                                        editLocalImageFirst: editLocalImageFirst,
                                        editLocalImageSecond: editLocalImageSecond,
                                        editLocalImageThird: editLocalImageThird) { [weak self] (error, _)  in
            guard let self else { return }
            if let error = error {
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else {
                FirestoreAPI.shared.createPost(post: post) { [weak self] _, postId in
                    guard let self = self else { return }
                    post.id = postId
                    self.screenLoaderDelegate?.hideScreenLoader()
                    //                MixpanelManager.shared.trackEvent(.createPost, value: MixpanelPost.initFromPost(post: self.post))
                    if post.isForSale {
                        //                    MixpanelManager.shared.trackEvent(.markedForSale, value: postId)
                    }
                    completion?()
                }
            }
        }
    }
    
    func setOrUpdateUserInterests(state: InterestVCState) {
        screenLoaderDelegate?.showScreenLoader()
        FirestoreAPI.shared.getUserData(userId: AccountManager.shared.user?.uid ?? "") { [weak self] (user, error) in
            guard let self else { return }
            if let error = error {
                self.screenLoaderDelegate?.hideScreenLoader()
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else if let user = user {
                user.selectedInterestCodes = self.interestManager.selectedCodes
                // if customInterestsTree != nil - we save it for user
                if self.interestManager.customInterestsTree != nil {
                    user.customTree = self.interestManager.customInterestsTree
                }
                
                FirestoreAPI.shared.saveUserData(user: user) { error in
                    if let error = error {
                        self.screenLoaderDelegate?.hideScreenLoader()
                        self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
                    } else {
                        //                        MixpanelManager.shared.trackEvent(.updateProfile, value: CHAnalyticUser.initFromUser(user: user))
                        if state == .register {
                            switch BuildManager.shared.buildType {
                            case .release:
                                self.updateOwnerData()
                            case .dev:
                                self.screenLoaderDelegate?.hideScreenLoader()
                                self.moveToHomeScreen()
                            }
                        } else {
                            self.screenLoaderDelegate?.hideScreenLoader()
                            self.showToastDelegate?.showInfo(message: "Interests updated", completion: nil)
                            self.updateInterestsScreenDelegate?.updateScreen()
                        }
                    }
                }
            }
        }
    }
    
    func updateOwnerData() {
        // get OWNER user data
        FirestoreAPI.shared.getUserData(userId: Constants.AppOwnerInfo.id) { [weak self] (owner, error) in
            guard let self else { return }
            if let error = error {
                self.screenLoaderDelegate?.hideScreenLoader()
                self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
            } else if let owner = owner, let currentUserId = AccountManager.shared.user?.uid {
                if owner.followersIds == nil {
                    owner.followersIds = [NotificationInfo(userId: currentUserId)]
                } else {
                    owner.followersIds?.append(NotificationInfo(userId: currentUserId))
                }
                // save OWNER updated data
                FirestoreAPI.shared.saveUserData(user: owner) { error in
                    self.screenLoaderDelegate?.hideScreenLoader()
                    if let error = error {
                        self.showMessageDelegate?.showAlert(error: error.localizedDescription, completion: nil)
                    } else {
                        self.moveToHomeScreen()
                    }
                }
            }
        }
    }
}
