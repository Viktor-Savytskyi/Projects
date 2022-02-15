//
//  DetailBannerCollectionViewCell.swift
//  StoreApp
//
//  Created by 12345 on 24.01.2022.
//

import UIKit

class DetailBannerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setConfigurations()
    }

    func fill(model: Screenshots) {
        if let image = model.image {
            bannerImage.setImage(url: image)
        }
    }
    
    func setConfigurations() {
        bannerImage.setCornerRadius(by: 10)
    }
    

}
