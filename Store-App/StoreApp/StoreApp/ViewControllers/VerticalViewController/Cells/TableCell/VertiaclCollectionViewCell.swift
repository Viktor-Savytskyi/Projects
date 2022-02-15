//
//  VertiaclCollectionViewCell.swift
//  StoreApp
//
//  Created by 12345 on 20.01.2022.
//

import UIKit
import Kingfisher

class VertiaclCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var separatorLabel: UILabel!
    @IBOutlet weak var reusebleView: ReusebleView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        visualConfigurations()
    }
    
    func visualConfigurations() {
        separatorLabel.backgroundColor = .quaternaryLabel
        reusebleView.button.titleLabel?.textColor = .systemBlue
        reusebleView.button.backgroundColor = .secondaryLabel
    }
    
    func fill(with model: GameListInfoResponse) {
        if let title = model.title, let description = model.shortDescription, let image = model.thumbnail {
            reusebleView.titleLabel.text = title
            reusebleView.decriptionLabel.text = description
            reusebleView.imageView.setImage(url: image)
        }
    }

}
