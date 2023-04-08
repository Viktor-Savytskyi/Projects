import Foundation
import UIKit

extension UIButton {
    func setUnderlinedTitle(title: String) {
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: titleColor(for: .normal)!, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: titleColor(for: .normal)!, range: NSRange(location: 0, length: title.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }   
}
