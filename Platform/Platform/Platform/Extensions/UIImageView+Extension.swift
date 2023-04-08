import UIKit
import SDWebImage

extension UIImageView {
	func load(url: URL) {
		sd_imageIndicator = SDWebImageActivityIndicator.gray
		sd_setImage(with: url, placeholderImage: nil)
	}
}
