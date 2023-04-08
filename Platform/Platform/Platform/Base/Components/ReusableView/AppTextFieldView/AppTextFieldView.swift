import UIKit

class AppTextFieldView: ViewFromXib {
	
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var errorLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		textField.font = UIFont.standartText
	}
	
	var errorText: String? {
		didSet {
			errorLabel.text = errorText
			errorLabel.isHidden = errorText == nil
		}
	}
	
	var placeholder: String = "" {
		didSet {
			textField.attributedPlaceholder = NSAttributedString(
				string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.textOnLight.withAlphaComponent(0.6),
							 .font: UIFont.placeholderText  ?? .systemFont(ofSize: 17)]
			)
		}
	}
}
