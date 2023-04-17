import Foundation

class UsersStorage {
    var users: [CHUser]?
    static let shared = UsersStorage()
    
    private init () { }
    //MARK: do not use UI layer in fetch like func parameter
    func featchUsers(screenAlertDelegate: ScreenAlertDelegate?, completion: (() -> Void)? = nil) {
        FirestoreAPI.shared.getAllUsers { [weak self] users, error in
            guard let self = self else { return }
            if let error = error {
                screenAlertDelegate?.showAlert(error: error.localizedDescription, completion: {
                    self.featchUsers(screenAlertDelegate: screenAlertDelegate, completion: completion)
                })
//                baseViewController?.showMessage(message: error.localizedDescription) { _ in
//                    self.featchUsers(baseViewController: baseViewController, completion: completion)
//                }
            } else {
                self.users = users
                completion?()
            }
        }
    }
}
