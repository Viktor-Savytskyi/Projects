import UIKit

class InterestCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var nameLabel: UILabel!

    func setup(name: String, isSelected: Bool) {
        nameLabel.text = name
        bgView.layer.cornerRadius = 15
        bgView.backgroundColor = isSelected ? Constants.Colors.viewBackgroundSecond : Constants.Colors.background
        nameLabel.textColor = isSelected ?  Constants.Colors.background : Constants.Colors.textOnLight
    }
}
