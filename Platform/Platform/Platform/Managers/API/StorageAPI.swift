import FirebaseStorage
import FirebaseAuth
import Foundation

class StorageAPI {
	
	static let shared = StorageAPI()
	
    func setProfileImage(profilePicImageData: Data, completion: @escaping ((Error?, String?) -> Void)) {
        guard let id = AccountManager.shared.user?.uid else { return }
        let profileImgReference = Storage.storage().reference().child(Constants.Firebase.avatarsStorageKey).child("\(id).png")
        profileImgReference.putData(profilePicImageData, metadata: nil) { (_, error) in
            if let error = error {
                completion(error, nil)
            } else {
                profileImgReference.downloadURL(completion: { url, downloadError in
                    if let url = url {
                        completion(nil, url.absoluteString)
                    } else {
                        completion(downloadError, nil)
                    }
                })
            }
        }
    }
	
	func uploadImage(imageData: Data, completion: @escaping ((Error?, String?) -> Void)) {
		guard let userId = AccountManager.shared.user?.uid else { return }
		let postImgReference = Storage.storage().reference()
			.child(Constants.Firebase.postsStorageKey)
			.child(userId)
			.child("\(UUID().uuidString).jpeg")
		postImgReference.putData(imageData, metadata: nil) { (_, error) in
			if let error = error {
				completion(error, nil)
			} else {
				postImgReference.downloadURL { url, _ in
					completion(nil, url?.absoluteString)
				}
			}
		}
	}
	
}
