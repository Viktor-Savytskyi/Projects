import UIKit

extension UIView {    
    func setCorners(corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: CGFloat = 0) {
        clipsToBounds = true
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
    
    func setBorder(borderWith: CGFloat = 1, borderColor: CGColor = UIColor.black.cgColor) {
        clipsToBounds = true
        layer.borderWidth = borderWith
        layer.borderColor = borderColor
    }
}
