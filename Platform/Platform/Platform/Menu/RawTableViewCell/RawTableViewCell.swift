import UIKit

class RawTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    static let identifier = "RawTableViewCell"
    
    func fill(with data: Section) {
        categoryNameLabel.text = data.name
    }
}
