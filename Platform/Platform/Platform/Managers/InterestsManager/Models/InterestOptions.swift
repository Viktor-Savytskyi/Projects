import UIKit
//MARK: use struct instead of class
class Category: Equatable, Codable {
    var code: String
	var children: [Category]?
	var visible = false
	
	private enum CodingKeys: String, CodingKey {
		case code, children
	}
	
    init(code: String, children: [Category]? = nil) {
        self.code = code
        self.children = children
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.code.lowercased() == rhs.code.lowercased()
    }
}
