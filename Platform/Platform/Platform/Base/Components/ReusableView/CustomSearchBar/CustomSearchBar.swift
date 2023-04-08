import UIKit

class CustomSearchBar: UISearchBar {
    
    func prepareSearchBar(plaseholder: String) {
        searchTextField.attributedPlaceholder = NSAttributedString(string: plaseholder,
                                                                   attributes: [.foregroundColor: Constants.Colors.textOnLight,
                                                                                .font: UIFont.standartText ?? UIFont.systemFont(ofSize: 17)])
        layer.cornerRadius = 15
        searchTextField.leftView?.tintColor = Constants.Colors.textOnLight
    }
}
