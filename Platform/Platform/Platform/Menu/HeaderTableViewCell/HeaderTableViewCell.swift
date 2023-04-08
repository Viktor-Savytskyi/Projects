import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    static let identifier = "HeaderTableViewCell"
    
    func fill(with data: Section) {
        headerLabel.text = data.name
    }
}
