import UIKit

class RawTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    //MARK: Use non-string for identifier

    func fill(with data: String) {
        categoryNameLabel.text = data
    }
}
