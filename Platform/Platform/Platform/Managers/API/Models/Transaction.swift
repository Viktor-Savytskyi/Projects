import Foundation

class Transaction: Codable {
	let sellerId: String
	let buyerId: String
	let postId: String
	var id: String?
	
	init(sellerId: String, buyerId: String, postId: String) {
		self.sellerId = sellerId
		self.buyerId = buyerId
		self.postId = postId
	}
}
