import UIKit

@IBDesignable
final class AppButton: UIButton {
	
	private let buttonHeight: CGFloat = 55.0

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	private func setup() {
        titleLabel?.font = UIFont.buttonTitle?.withSize(17)
		layoutIfNeeded()
		preparePrimaryButton()
	}
    
    func preparePrimaryButton() {
        layer.cornerRadius = buttonHeight / 2.0
        backgroundColor = Constants.Colors.buttonBackground
        tintColor = Constants.Colors.textOnLight
        layer.borderWidth = 1.0
        layer.borderColor = Constants.Colors.textOnLight.cgColor
        
    }
	
	override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: buttonHeight)
	}

}
