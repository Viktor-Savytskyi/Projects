import Foundation

class UsersStorage {
    var users: [CHUser]?
    static let shared = UsersStorage()
    
    private init () { }
    
    func featchUsers(baseViewController: BaseViewController?, completion: (() -> Void)? = nil) {
        FirestoreAPI.shared.getAllUsers { [weak self] users, error in
            guard let self = self else { return }
            if let error = error {
                baseViewController?.showMessage(message: error.localizedDescription) { _ in
                    self.featchUsers(baseViewController: baseViewController, completion: completion)
                }
            } else {
                self.users = users
                completion?()
            }
        }
    }
}
