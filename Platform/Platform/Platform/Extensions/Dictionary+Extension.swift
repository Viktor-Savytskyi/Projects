import Foundation

extension Dictionary where Key: Encodable, Value: Encodable {
	func toData() -> Data? {
		let encoder = JSONEncoder()
		if let jsonData = try? encoder.encode(self) {
			return jsonData
		}
		return nil
	}
}
