import UIKit

protocol ThemeButtonDelegate: AnyObject {
    func themeButtonTapped()
}

class ThemeButtonsView: ViewFromXib {
    
    @IBOutlet weak var firstThemeButton: UIButton!
    @IBOutlet weak var secondThemeButton: UIButton!
    @IBOutlet weak var thirdThemeButton: UIButton!
    
    private var themesButtonsArray = [UIButton]()
    weak var themeButtonDelegate: ThemeButtonDelegate?
    var numberOfTheme: NumberOfTheme?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        themesButtonsArray = [
            firstThemeButton,
            secondThemeButton,
            thirdThemeButton
        ]
        themesButtonsArray.forEach { button in
            button.layer.cornerRadius = button.frame.height / 2.0
            button.backgroundColor = Constants.Colors.secondaryButtonBackground
            button.tintColor = Constants.Colors.background
            button.layer.borderColor = UIColor.black.cgColor
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    @IBAction func choseSomeThemeClick(_ sender: UIButton) {
        switch sender {
        case firstThemeButton:
            numberOfTheme = .firstTheme
        case secondThemeButton:
            numberOfTheme = .secondTheme
        case thirdThemeButton:
            numberOfTheme = .thirdTheme
        default:
            break
        }
        themeButtonDelegate?.themeButtonTapped()
    }
}
