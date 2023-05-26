import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headerLabel: UILabel!
    //MARK: Use non-string for identifier
    
    func fill(with name: String) {
        headerLabel.text = name
    }
}
