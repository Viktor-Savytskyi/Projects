import UIKit
import WebKit

class WebViewController: BaseViewController {

    @IBOutlet weak var webView: WKWebView!
	
	var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()
    }
    
    private func loadURL() {
        if let url = URL(string: url ?? "") {
            let request = URLRequest(url: url)
			showLoader()
			webView.navigationDelegate = self
            webView.load(request)
		} else {
			showMessage(message: Constants.ErrorTitle.invalidUrl) { _ in
				self.navigationController?.popViewController(animated: true)
			}
		}
    }
}

extension WebViewController: WKNavigationDelegate {
	func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		hideLoader()
	}

	func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
		hideLoader()
		showMessage(message: error.localizedDescription) { _ in
			self.navigationController?.popViewController(animated: true)
		}
	}
}
