import Foundation

extension FirestoreAPI {
	func createTransaction(transaction: Transaction, completion: ((Error?) -> Void)?) {
		let docRef = db.collection("Transaction").document()
		transaction.id = docRef.documentID
		docRef.setData(transaction.dictionary ?? [:], completion: completion)
	}
}
