import UIKit
import WebKit

class SocialNetworkWebViewController: BaseViewController {
    
    @IBOutlet weak var socialNetworkWebView: WKWebView!
    
    private var userName: String?
    private var userSocialNetworkType: SocialNetworkType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWebPage(userName: userName)
    }
    
    func fill(userSocialNetworkName: String?, socialNetworkType: SocialNetworkType) {
        userName = userSocialNetworkName
        userSocialNetworkType = socialNetworkType
    }
    
    private func showWebPage(userName: String?) {
        guard let userName = userName else { return }
        var url: URL?
        switch userSocialNetworkType {
        case .twitter:
            url = URL(string: "https:www.twitter.com/\(userName)")
        case .instagram:
            url = URL(string: "https:www.instagram.com/\(userName)")
        case .tikTok:
            url = URL(string: "https:www.tiktok.com/@\(userName)")
        case .facebook:
            url = URL(string: "https:www.facebook.com/\(userName)")
        default:
            break
        }
        guard let url = url else { return }
        socialNetworkWebView.load(URLRequest(url: url))
    }
    
    @IBAction func closeClick(_ sender: Any) {
        dismiss(animated: true)
    }
}
