import Foundation
import UIKit

extension UILabel {
    
	func setupColorAttributesForText(title: String, textForRecolor: [String], colorForHighlight: UIColor) {
        let mainAttributedText = NSMutableAttributedString(string: title,
                                                           attributes: [.foregroundColor: textColor ?? Constants.Colors.textOnLight,
                                                                        .font: font ?? .standartText!])
		let attributes = [NSAttributedString.Key.foregroundColor: colorForHighlight]
		textForRecolor.forEach { subString in
			let range = (title as NSString).range(of: "\(subString)", options: .caseInsensitive)
			mainAttributedText.addAttributes(attributes, range: NSRange(location: range.location, length: range.length))
		}
		
        attributedText = mainAttributedText
    }
    
    func setUnderlinedText() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: text ?? "", attributes: underlineAttribute)
        attributedText = underlineAttributedString
    }
    
    func actualNumberOfLines() -> Int {
        layoutIfNeeded()
        guard let myText = text as? NSString else { return 0}
        let rect = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }
}
