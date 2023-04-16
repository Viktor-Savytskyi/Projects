import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
        
    func fill(with name: String) {
        headerLabel.text = name
    }
}
