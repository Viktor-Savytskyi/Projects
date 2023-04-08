import Foundation
import FirebaseAuth

class LoginAPI {
	
	static let shared = LoginAPI()

	func login(email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
		Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
			completion(authResult, error)
		}
	}
	
	func registerUser(email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			completion(authResult, error)
		}
	}
	
	func updateUserData(completion: @escaping ((Error?) -> Void)) {
		Auth.auth().currentUser?.reload(completion: { error in
			completion(error)
		})
	}
}
