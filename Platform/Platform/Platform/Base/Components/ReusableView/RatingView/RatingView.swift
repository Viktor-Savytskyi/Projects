import UIKit
import Cosmos

class RatingView: ViewFromXib {
    
    @IBOutlet weak var starsRatingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        
    }
}
