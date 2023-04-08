import Foundation
import UIKit

class ProfileInfoView: ViewFromXib {
    
    @IBOutlet weak var themeButtonsView: ThemeButtonsView!
    @IBOutlet weak var aboutMeContentView: UIView!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var socialsContentView: UIView!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var tikTokButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    private var socialNetworkButtonsArray = [UIButton]()
    private var themeButtonsArray = [UIButton]()
    var completion: ((SocialNetworkType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        bioTextView.placeholder = "Your bio is empty"
        bioTextView.layer.cornerRadius = 4
        bioTextView.isEditable = false
        aboutMeContentView.setCorners(radius: 15)
        aboutMeContentView.setBorder()
        socialsContentView.setCorners(radius: 15)
        socialsContentView.setBorder()
        twitterButton.setImage(UIImage(named: "twitterSelected"), for: .normal)
        twitterButton.setImage(UIImage(named: "twitter"), for: .disabled)
        instagramButton.setImage(UIImage(named: "instagramSelected"), for: .normal)
        instagramButton.setImage(UIImage(named: "instagram"), for: .disabled)
        tikTokButton.setImage(UIImage(named: "tikTokSelected"), for: .normal)
        tikTokButton.setImage(UIImage(named: "tikTok"), for: .disabled)
        facebookButton.setImage(UIImage(named: "facebookSelected"), for: .normal)
        facebookButton.setImage(UIImage(named: "facebook"), for: .disabled)
        themeButtonsView.isHidden = true
        prepareButtons()
    }
    
    private func prepareButtons() {
        socialNetworkButtonsArray = [
            twitterButton,
            instagramButton,
            tikTokButton,
            facebookButton
        ]
        socialNetworkButtonsArray.forEach { $0.setTitle("", for: .normal) }
        
        themeButtonsArray = [
            themeButtonsView.firstThemeButton,
            themeButtonsView.secondThemeButton,
            themeButtonsView.thirdThemeButton
        ]
        themeButtonsArray.forEach { button in
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont.boldFont?.withSize(14)
            button.tintColor = Constants.Colors.textOnLight
            button.isHidden = true
            button.setBorder(borderWith: 1)
        }
    }
    
    func setSocialNetworkButtonsImagesState(user: CHUser?) {
        let twitterUserName = user?.twitterUserName
        let instagramUserName = user?.instagramUserName
        let tikTokUserName = user?.tikTokUserName
        let facebookUserName = user?.facebookUserName
        twitterButton.isEnabled = twitterUserName != nil && twitterUserName != ""
        instagramButton.isEnabled = instagramUserName != nil && instagramUserName != ""
        tikTokButton.isEnabled = tikTokUserName != nil && tikTokUserName != ""
        facebookButton.isEnabled =  facebookUserName != nil && facebookUserName != ""
    }
    
    func setupUserData(user: CHUser?) {
        guard let user = user else { return }
        bioTextView.text = user.bio
        
        themeButtonsView.isHidden = user.firstTheme == nil && user.secondTheme == nil && user.thirdTheme == nil
        themeButtonsView.firstThemeButton.isHidden = user.firstTheme == nil
        themeButtonsView.secondThemeButton.isHidden = user.secondTheme == nil
        themeButtonsView.thirdThemeButton.isHidden = user.thirdTheme == nil
        themeButtonsView.firstThemeButton.setTitle(user.firstTheme != nil ? user.firstTheme?.uppercased() : nil, for: .normal)
        themeButtonsView.secondThemeButton.setTitle(user.secondTheme != nil ? user.secondTheme?.uppercased() : nil, for: .normal)
        themeButtonsView.thirdThemeButton.setTitle(user.thirdTheme != nil ? user.thirdTheme?.uppercased() : nil, for: .normal)
        
        setSocialNetworkButtonsImagesState(user: user)
    }
    
    @IBAction func choseSocialNetwork(_ sender: UIButton) {
        var socialNetworkType: SocialNetworkType!
        switch sender {
        case twitterButton:
            socialNetworkType = .twitter
        case instagramButton:
            socialNetworkType = .instagram
        case tikTokButton:
            socialNetworkType = .tikTok
        case facebookButton:
            socialNetworkType = .facebook
        default:
            break
        }
        completion?(socialNetworkType)
    }
}
