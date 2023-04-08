import UIKit

protocol SetChangesAndCancelButtonTapDelegate: AnyObject {
    func didTapSetButton()
	func didTapSetButton(with parent: Category?, newTitle: String)
    func didTapCancelButton()
}

extension SetChangesAndCancelButtonTapDelegate {
    func didTapSetButton(with parent: Category? = nil, newTitle: String) {
        didTapSetButton(with: parent, newTitle: newTitle)
    }
    func didTapSetButton() {
        didTapSetButton()
    }
}

class TextFieldViewWithButtons: ViewFromXib {
    
    @IBOutlet weak var textFieldView: AppTextFieldView!
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    weak var buttonsDelegate: SetChangesAndCancelButtonTapDelegate?
    var parentCategory: Category?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let rightTextFieldView = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 70,
                                                      height: textFieldView.textField.frame.size.height))
        textFieldView.textField.rightView = rightTextFieldView
        textFieldView.textField.rightViewMode = .always
    }
    
	func showOffensiveWordsEnteringError(errorIn: String, completion: (() -> Void)? = nil) {
		textFieldView.textField.placeholder = "\(errorIn) not supported. Try again."
		textFieldView.textField.attributedPlaceholder = NSAttributedString(
			string: textFieldView.textField.placeholder ?? "",
			attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.error,
                         .font: UIFont.placeholderText?.withSize(12) ?? .systemFont(ofSize: 17)])
		textFieldView.textField.text = nil
		completion?()
	}
    
    func clearOffensiveWordsEnteredError() {
        textFieldView.textField.attributedPlaceholder = NSAttributedString(
            string: "{LIVE TEXT}",
            attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.textOnLight,
                         .font: UIFont.placeholderText ?? .systemFont(ofSize: 17)])
    }
    
    @IBAction func setChangesClick(_ sender: Any) {
        if parentCategory != nil {
            buttonsDelegate?.didTapSetButton(with: parentCategory, newTitle: textFieldView.textField.text!)
        } else {
            buttonsDelegate?.didTapSetButton()
        }
    }
    
    @IBAction func cancelChangesClick(_ sender: Any) {
        buttonsDelegate?.didTapCancelButton()
    }
}
