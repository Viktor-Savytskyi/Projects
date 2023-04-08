import UIKit

class InterestCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var bgView: UIView!
	@IBOutlet weak var nameLabel: UILabel!

	func setup(name: String, isSelected: Bool) {
		nameLabel.text = name
		bgView.layer.cornerRadius = 15
		bgView.backgroundColor = isSelected ? #colorLiteral(red: 0.06274509804, green: 0.4, blue: 0.7098039216, alpha: 1) : #colorLiteral(red: 1, green: 0.7799999714, blue: 0.7059999704, alpha: 1)
	}
}
