import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreAPI {
	
	static let shared = FirestoreAPI()
	
	let db = Firestore.firestore()
	
	let postCollectionName = "Posts"
	let transactionCollectionName = "Transactions"
	
	private init() {}
}
