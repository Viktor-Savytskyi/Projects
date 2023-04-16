import UIKit
import SDWebImage

class ImagesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var isForSaleMark: UIImageView!
    
    func fill(with data: String, isForSale: Bool) {
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        postImageView.sd_setImage(with: URL(string: data))
        postImageView.setCorners(radius: 20)
        isForSaleMark.isHidden = !isForSale
    }
}
