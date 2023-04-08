import UIKit

class InterestCategoryView: ViewFromXib {
	
	@IBOutlet weak var plusButton: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var arrowImgView: UIImageView!
	@IBOutlet weak var allSeclectedView: UIView!
	
	var onPressedPlus: (() -> Void)?
	var onPressed: (() -> Void)?
	var category: Category!
	weak var delegate: InterestChangedDelegate?
	private let interestManager = InterestManager.shared

    func setup(category: Category,
               delegate: InterestChangedDelegate?,
               onPressedPlus: (() -> Void)?,
               onPressed: (() -> Void)?) {
        self.category = category
        self.delegate = delegate
        self.onPressedPlus = onPressedPlus
        self.onPressed = onPressed
        nameLabel.text = category.code
        arrowImgView.image = UIImage()
		let isCategorySelected = self.interestManager.stateOf(category: category) == .selected
        plusButton.setImage(isCategorySelected
                                         ? #imageLiteral(resourceName: "selectedPlus.pdf")
                                         : #imageLiteral(resourceName: "plus.pdf"),
                                         for: .normal)
	}

	@IBAction func bgButtonClicked(_ sender: Any) {
		onPressed?()
	}
	
	@IBAction func plussButtonClicked(_ sender: Any) {
		onPressedPlus?()
	}
}
