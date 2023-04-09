import Foundation
import UIKit

protocol ViewFromXibProtocol {
}

extension ViewFromXibProtocol where Self: UIView {
    func xibSetup() {
        let view = loadViewFromNib()
        
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.theClassName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return UIView() }
        view.clipsToBounds = true
        return view
    }
}

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
    
    class func getTheClassName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
