import UIKit
import DropDown
import SDWebImage

class DropDownSearchListCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!    
    @IBOutlet weak var firstLastNamesLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    func setWith(user: CHUser?) {
        guard let user else { return }
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
		if let imageUrlString = user.avatarImageUrl {
			avatarImageView.sd_setImage(with: URL(string: imageUrlString))
		} else {
			avatarImageView.image = UIImage(named: "noAvatar")
		}
        firstLastNamesLabel.text = "\(user.firstName) \(user.lastName)".uppercased()
        firstLastNamesLabel.font = UIFont.boldFont?.withSize(13)
        userNameLabel.text = "@\(user.userName)"
    }
    
    func setWithSearched(text: String) {
        firstLastNamesLabel.text = text
        firstLastNamesLabel.font = UIFont.smallText
        userNameLabel.text = nil
        avatarImageView.image = UIImage(named: "searchLoop")
    }
}
