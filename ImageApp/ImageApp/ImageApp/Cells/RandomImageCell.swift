//
//  RandomImageCell.swift
//  ImageApp
//
//  Created by 12345 on 17.09.2021.
//

import UIKit

class RandomImageCell: UICollectionViewCell {
    
    @IBOutlet weak var randomImg: UIImageView!
    @IBOutlet weak var heartImage: UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.randomImg.image = nil
    }
}
