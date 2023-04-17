import UIKit

//MARK: this is helper not Manager
class UIHelper {
	static func addWaterSign(original: UIImage) -> UIImage {
		let watermarkImage = #imageLiteral(resourceName: "plus")
		let size = original.size
		let scale = original.scale

		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		original.draw(in: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height))
		let waterSignWidth = size.width / 5
		let waterSignHeight = size.height / 5
		watermarkImage.draw(in: CGRect(x: size.width - waterSignWidth, y: size.height - size.height / 5, width: waterSignWidth, height: waterSignHeight))

		let result = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return result
	}
}
