import Foundation
import UIKit

struct TextWithLink {
    var title: String
    var callBack: (() -> Void)?
}

class UILabelWithLinks: UILabel {
    
    private var links: [NSRange: (() -> Void)] = [:]
    
    func addTextWithTaggedUsersNames(_ text: String?) {
        guard var text else { return }
        let tabBarVC = Utils.window?.rootViewController as? UITabBarController
        let rootNavigationVC = tabBarVC?.viewControllers?[tabBarVC?.selectedIndex ?? 0] as? UINavigationController
        var taggedNames = [TextWithLink]()
        
        UsersStorage.shared.users?.forEach { user in
            let selectedUserId = "@\(user.id)"
            if text.contains(selectedUserId) {
                let moveToUserDetailsCompletion: (() -> Void)? = {
                    let profilePageVC = ProfilePageViewController()
                    profilePageVC.userId = user.id
                    rootNavigationVC?.pushViewController(profilePageVC, animated: true)
                }
                let userName = "@\(user.userName)"
                text = text.replacingOccurrences(of: selectedUserId, with: userName)
                taggedNames.append(TextWithLink.init(title: userName, callBack: moveToUserDetailsCompletion))
            }
        }
        
        addTextWithLinks(text, taggedNames, linkedTextColor: .blue)
    }
    
    func addTextWithLinks(_ text: String, _ textWithLinks: [TextWithLink], linkedTextColor: UIColor = Constants.Colors.textOnLight) {
        links = [:]
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = textAlignment
        let actionAttributedString = NSMutableAttributedString(string: text, attributes: [
            .foregroundColor: Constants.Colors.textOnLight,
            .font: UIFont.smallText ?? .systemFont(ofSize: 13),
			.paragraphStyle: paragraphStyle
        ])
        
        let linkTextAttributes: [NSAttributedString.Key: Optional<NSObject>] = [
            .foregroundColor: linkedTextColor,
            .font: UIFont.linkText,
            .underlineStyle: linkedTextColor == Constants.Colors.textOnLight
            ? NSUnderlineStyle.thick.rawValue as NSObject
            : nil
        ]
        
        textWithLinks.forEach { textWithLink in
            let range = (text as NSString).range(of: "\(textWithLink.title)", options: .caseInsensitive)
            actionAttributedString.addAttributes(linkTextAttributes as [NSAttributedString.Key: Any], range: NSRange(location: range.location, length: range.length))
            let linkRange = NSRange.init(location: range.location, length: range.length)
            links[linkRange] = textWithLink.callBack
        }
        
        attributedText = actionAttributedString
        
        let tapLink = UITapGestureRecognizer(target: self, action: #selector(fieldTapped(_:)))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapLink)
    }
    
    @objc private func fieldTapped(_ tap: UITapGestureRecognizer) {
        guard let attributedText = attributedText, let label = tap.view as? UILabel, label == self, tap.state == .ended else { return }
        let location = tap.location(in: label)
        let textStorage = NSTextStorage(attributedString: attributedText)
        let textContainer = NSTextContainer(size: label.bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        links.forEach { (range, callback) in
            if range.contains(characterIndex) {
                callback()
            }
        }
    }
}
