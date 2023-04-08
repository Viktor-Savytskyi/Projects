import UIKit

class UploadPhotoView: ViewFromXib {
	
	@IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var waterMarkImageView: UIImageView!
    
    var onCliked: (() -> Void)?
	
	var image: UIImage? {
		didSet {
			imgView.image = image
		}
	}
	
	var isActive: Bool = true {
		didSet {
			isUserInteractionEnabled = isActive
		}
	}

	override func setupViews() {
		super.setupViews()
        imgView.layer.cornerRadius = 10
		let gesture = UITapGestureRecognizer(target: self, action: #selector(onPressed))
		addGestureRecognizer(gesture)
	}
	
	@objc private func onPressed() {
		onCliked?()
	}
}
