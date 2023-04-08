import UIKit

extension UITextField {
    
    func addPermanentSymbolOnLeft(symbol: String = "", customFontSize: CGFloat? = nil, leftViewWidth: CGFloat = 30) {
        let insertSpaceFromLeftSide: CGFloat = 3
        let viewAndLabelWidth: CGFloat = leftViewWidth
        let viewHeight: CGFloat = frame.size.height * 0.9
        let leftTextFieldView = UIView(frame: CGRect(x: insertSpaceFromLeftSide, y: 0, width: viewAndLabelWidth, height: viewHeight))
        let label = UILabel(frame: CGRect(x: insertSpaceFromLeftSide, y: 0, width: leftTextFieldView.frame.width, height: leftTextFieldView.frame.height ))
        label.text = symbol
        label.textColor = textColor
        label.font = UIFont(name: font?.fontName ?? "ABC Marfa Unlicensed Trial", size: customFontSize ?? font?.pointSize ?? 17)
        label.backgroundColor = backgroundColor
        leftTextFieldView.addSubview(label)
        leftViewMode = .always
        leftView = leftTextFieldView
    }
}
