import UIKit
import SDWebImage

class UserPostsCollectionViewCell: UICollectionViewCell {
        
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var markForSale: UIImageView!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setCorners(radius: 15)
    }
    func setup(with post: Post) {
        postImage.sd_setImage(with: URL(string: post.firstImage.imageUrl))
        markForSale.isHidden = !post.isForSale
    }
    
}
