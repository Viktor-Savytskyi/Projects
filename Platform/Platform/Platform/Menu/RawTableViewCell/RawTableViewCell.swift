import UIKit

class RawTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    static let identifier = "RawTableViewCell"
    
    func fill(with data: String) {
        categoryNameLabel.text = data
    }
}
