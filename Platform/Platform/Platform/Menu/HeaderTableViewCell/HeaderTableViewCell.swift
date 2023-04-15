import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    static let identifier = "HeaderTableViewCell"
    
    func fill(with name: String) {
        headerLabel.text = name
    }
}
