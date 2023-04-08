import Foundation

extension String {
    var doubleValue: Double? {
        Double(replacingOccurrences(of: ",", with: "."))
    }
    
	func trim() -> String {
		trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
