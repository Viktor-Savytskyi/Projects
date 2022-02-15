//
//  BannerCollectionViewCell.swift
//  StoreApp
//
//  Created by 12345 on 21.01.2022.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var reusebleView: ReusebleView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        visualConfigurations()
    }

    func fill(with model: GameListInfoResponse) {
        if let title = model.title, let description = model.shortDescription, let image = model.thumbnail {
            reusebleView.titleLabel.text = title
            reusebleView.decriptionLabel.text = description
            reusebleView.imageView.setImage(url: image)
            bannerImage.setImage(url: image)
            topTitleLabel.text = title
            descriptionLabel.text = description
        }
    }
    
    func visualConfigurations() {
        reusebleView.button.titleLabel?.textColor = .white
        reusebleView.imageView.setCornerRadius(by: 10)
        bannerImage.setCornerRadius(by: 10)
        reusebleView.button.backgroundColor = .systemGray
    }
    
}
