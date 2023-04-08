import UIKit
import SDWebImage
import Zoomy

class PreviewImageViewController: BaseViewController {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        addZoom()
    }
    
    private func addZoom() {
        addZoombehavior(for: postImageView, settings: .instaZoomSettings)
    }
    
    private func setImage() {
        postImageView.sd_setImage(with: URL(string: imageURL))
    }
    
    @IBAction func closeClick(_ sender: Any) {
        dismiss(animated: true)
    }
}
