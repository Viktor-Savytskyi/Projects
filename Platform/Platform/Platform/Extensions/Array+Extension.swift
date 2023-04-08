import Foundation

extension Array where Element: Equatable {
	func satisfy(array: [Element]) -> Bool {
		return self.allSatisfy(array.contains)
	}
}
