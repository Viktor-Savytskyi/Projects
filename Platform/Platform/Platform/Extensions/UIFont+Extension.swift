import Foundation
import UIKit

extension UIFont {
    
    static let regularFont = UIFont(name: Constants.Font.regularFont, size: 1)
	static let boldFont = UIFont(name: Constants.Font.boldFont, size: 1)
	
	static let title = regularFont?.withSize(30)
    static let subtitle = boldFont?.withSize(26)
    static let buttonTitle = boldFont?.withSize(14)
    static let navigationBarTitle = boldFont?.withSize(35)
    static let standartText = regularFont?.withSize(17)
    static let smallText = regularFont?.withSize(13)
    static let placeholderText = regularFont?.withSize(17)
    static let linkText = regularFont?.withSize(13)
}
