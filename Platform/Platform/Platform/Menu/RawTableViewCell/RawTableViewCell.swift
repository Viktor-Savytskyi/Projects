import UIKit

class RawTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
        
    func fill(with data: String) {
        categoryNameLabel.text = data
    }
}
