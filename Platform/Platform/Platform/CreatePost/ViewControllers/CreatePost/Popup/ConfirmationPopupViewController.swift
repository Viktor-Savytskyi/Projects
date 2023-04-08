import UIKit

class ConfirmationPopupViewController: UIViewController {

	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var rootView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var deleteButton: UIButton!
	
	var onDelete: (() -> Void)?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		backgroundView.alpha = 0.6
		rootView.setCorners(radius: 15)
		cancelButton.setCorners(radius: 10)
		cancelButton.setBorder(borderColor: Constants.Colors.textOnLight.withAlphaComponent(0.2).cgColor)
		deleteButton.setBorder(borderColor: Constants.Colors.textOnLight.withAlphaComponent(0.2).cgColor)
		deleteButton.setCorners(radius: 10)
    }
		
	@IBAction func deleteButtonClicked(_ sender: Any) {
		dismiss(animated: true)
		onDelete?()
	}
	
	@IBAction func cancelButtonClicked(_ sender: Any) {
		dismiss(animated: true)
	}
}
