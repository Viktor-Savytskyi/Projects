//
//  ReusebleView.swift
//  StoreApp
//
//  Created by 12345 on 21.01.2022.
//

import UIKit

class ReusebleView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var decriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var descriptionOfButton: UILabel!
    
    let nibName = "ReusebleView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        setConfigurations()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func setConfigurations() {
        button.setCornerRadius(by: Int(button.frame.size.height * 0.43))
        imageView.setCornerRadius(by: Int(imageView.frame.size.height * 0.17))
    }
}
