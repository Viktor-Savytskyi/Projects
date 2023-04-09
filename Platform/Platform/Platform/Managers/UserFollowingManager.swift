import Foundation

class UserFollowingManager {
    private var currentUser: CHUser?
    private var user: CHUser?
    var completion: ((CHUser) -> Void)?
//    weak var baseViewController: BaseViewController?
    
    weak var updateScreenDelegat: UpdateScreenDelegate?
    
    static let shared = UserFollowingManager()
    
    private init() { }
    
    func switchFollowState(userId: String, completion: ((CHUser) -> Void)?) {
//        self.baseViewController = baseViewController
        fetchUserData(userId: userId)
        self.completion = completion
    }
    
    private func fetchUserData(userId: String) {
//        baseViewController?.showLoader()
        updateScreenDelegat?.showScreenLoader()
        FirestoreAPI.shared.getUserData(userId: userId) { [weak self] user, error in
            guard let self = self else { return }
            if let error = error {
//                self.baseViewController?.hideLoader()
//                self.baseViewController?.showMessage(message: error.localizedDescription)
                self.updateScreenDelegat?.hideScreenLoader()
                self.updateScreenDelegat?.showAlert(error: error)
            } else {
                self.user = user
                self.fetchCurrentUser()
            }
        }
    }
    
    private func fetchCurrentUser() {
        guard let currentUserId = AccountManager.shared.userId else { return }
        
        FirestoreAPI.shared.getUserData(userId: currentUserId) { [weak self] currentUser, error in
            guard let self = self else { return }
//            self.baseViewController?.hideLoader()
//            self.updateScreenDelegat?.hideScreenLoader()
            if let error = error {
                self.updateScreenDelegat?.showAlert(error: error)
//                self.baseViewController?.showMessage(message: error.localizedDescription)
            } else {
                self.currentUser = currentUser
                self.updateFollowState()
                self.saveFollowState()
            }
        }
    }
   
    func updateFollowState() {
        guard let currentUser, let user else { return }
        if let indexForRemoveInCurrentUser = currentUser.followedUserIds?.map({ $0.userId }).firstIndex(of: user.id) {
            currentUser.followedUserIds?.remove(at: indexForRemoveInCurrentUser)
        } else {
            if currentUser.followedUserIds != nil {
                currentUser.followedUserIds?.append(NotificationInfo(userId: user.id))
            } else {
                currentUser.followedUserIds = [NotificationInfo(userId: user.id)]
            }
        }
        
        if let indexForRemoveInSomeUser = user.followersIds?.map({ $0.userId }).firstIndex(of: currentUser.id) {
            user.followersIds?.remove(at: indexForRemoveInSomeUser)
        } else {
            if user.followersIds != nil {
                user.followersIds?.append(NotificationInfo(userId: currentUser.id))
            } else {
                user.followersIds = [NotificationInfo(userId: currentUser.id)]
            }
        }
    }
    
    func saveFollowState() {
        guard let currentUser, let user else { return }
//        self.baseViewController?.showLoader()
//        updateScreenDelegat?.showScreenLoader()
        FirestoreAPI.shared.saveUserData(user: currentUser) { [weak self] error in
            guard let self else { return }
            if let error = error {
//                self.baseViewController?.hideLoader()
//                self.baseViewController?.showMessage(message: error.localizedDescription)
                self.updateScreenDelegat?.hideScreenLoader()
                self.updateScreenDelegat?.showAlert(error: error)
            } else {
                FirestoreAPI.shared.saveUserData(user: user) { error in
//                    self.baseViewController?.hideLoader()
                    self.updateScreenDelegat?.hideScreenLoader()
                    if let error = error {
//                        self.baseViewController?.showMessage(message: error.localizedDescription)
                        self.updateScreenDelegat?.showAlert(error: error)

                    } else {
                        let isFollowNewValue = (user.followersIds?.compactMap({ $0.userId }) ?? []).contains(currentUser.id)
//                        MixpanelManager.shared.trackEvent(.follow, value: FollowObject(isFollow: isFollowNewValue, userId: user.id))
                        self.completion?(user)
                    }
				}
			}
		}
	}
	
}
