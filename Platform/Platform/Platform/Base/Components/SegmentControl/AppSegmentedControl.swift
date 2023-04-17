import UIKit

enum AppSegments: Int {
    case profilePostsSelected
    case bookSegmentSelected
    case wishListSelected
    case profile
    
    var selectedSegmentImageName: String {
        switch self {
        case .profilePostsSelected:
            return "profilePostsSelected"
        case .bookSegmentSelected:
            return "bookSegmentSelected"
        case .wishListSelected:
            return "wishListSelected"
        case .profile:
            return "profile"
        }
    }
}

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
        
        guard let appSegment = AppSegments(rawValue: selectedSegmentIndex) else { return }
        setImage(UIImage(named: appSegment.selectedSegmentImageName), forSegmentAt: selectedSegmentIndex)
    }
}
