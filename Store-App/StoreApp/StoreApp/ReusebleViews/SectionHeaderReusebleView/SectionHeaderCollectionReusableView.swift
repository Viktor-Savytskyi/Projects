//
//  SectionHeaderCollectionReusableView.swift
//  StoreApp
//
//  Created by 12345 on 25.01.2022.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var headerTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerTitleLabel.text = "Whats We`re Playing"
    }
    
}
