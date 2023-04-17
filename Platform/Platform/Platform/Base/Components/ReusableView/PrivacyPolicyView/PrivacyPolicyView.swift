import UIKit

class PrivacyPolicyView: ViewFromXib {
    
    @IBOutlet weak var privacyPolicyLabel: UILabelWithLinks!
    //MARK: view should not contain the navigation as parameter
    func prepareLink(navigationController: UINavigationController?) {
        let privacyPolicyCallback: (() -> Void)? = {
            let webVC = WebViewController()
            webVC.setUrl(url: Constants.URLs.privacyPolicy)
            navigationController?.pushViewController(webVC, animated: true)
        }
        let termsCallback: (() -> Void)? = {
            let webVC = WebViewController()
            webVC.setUrl(url: Constants.URLs.termsOfUse)
            navigationController?.pushViewController(webVC, animated: true)
        }

        let termsOfService = TextWithLink(title: "Terms of Service", callBack: termsCallback)
        let privacyPolicy = TextWithLink(title: "Privacy Policy", callBack: privacyPolicyCallback)
        let text = "By continuing, you agree to our \(termsOfService.title) \nand acknowledge our \(privacyPolicy.title)"
        privacyPolicyLabel.addTextWithLinks(text, [termsOfService, privacyPolicy])
    }
}
