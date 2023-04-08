import UIKit

class AppSegmentedControl: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // setup clear background for segment control
        let tintColorImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
        setBackgroundImage(tintColorImage, for: .normal, barMetrics: .default)
        setDividerImage(tintColorImage, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        setEnabled(false, forSegmentAt: 1)
        setEnabled(false, forSegmentAt: 2)
    }
    
    func setSegmentImages(selectedSegmentIndex: Int = 0) {
        setImage(UIImage(named: "profilePosts"), forSegmentAt: 0)
        setImage(UIImage(named: "bookSegment"), forSegmentAt: 1)
        setImage(UIImage(named: "wishList"), forSegmentAt: 2)
        setImage(UIImage(named: "profileWithAlpha"), forSegmentAt: 3)
        
        switch selectedSegmentIndex {
        case 0:
            setImage(UIImage(named: "profilePostsSelected"), forSegmentAt: selectedSegmentIndex)
        case 1:
            setImage(UIImage(named: "bookSegmentSelected"), forSegmentAt: selectedSegmentIndex)
        case 2:
            setImage(UIImage(named: "wishListSelected"), forSegmentAt: selectedSegmentIndex)
        case 3:
            setImage(UIImage(named: "profile"), forSegmentAt: selectedSegmentIndex)
        default:
            break
        }
    }
}
