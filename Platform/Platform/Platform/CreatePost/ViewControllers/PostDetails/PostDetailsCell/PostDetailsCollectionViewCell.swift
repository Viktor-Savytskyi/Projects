import UIKit

class PostDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentViewForImage: UIView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var forSaleMarkImageView: UIImageView!
    @IBOutlet weak var waterMarkImageView: UIImageView!
    
    func fill(with data: ImageWithStatus, index: Int, isForSale: Bool) {
        postImageView.sd_setImage(with: URL(string: data.imageUrl))
        contentViewForImage.setBorder()
        contentViewForImage.setCorners(radius: 20)
        waterMarkImageView.isHidden = index == 0 ? false : true
        forSaleMarkImageView.isHidden = !isForSale

    }
}
