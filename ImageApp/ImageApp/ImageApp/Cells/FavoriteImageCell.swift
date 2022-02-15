//
//  FavoriteImageCell.swift
//  ImageApp
//
//  Created by 12345 on 26.10.2021.
//

import UIKit

class FavoriteImageCell: UICollectionViewCell {
    
    @IBOutlet weak var favoriteImage: UIImageView?
    @IBOutlet weak var checkMarkLabel: UILabel!
    
    var isEditingMode = false {
        didSet {
            checkMarkLabel.isHidden = !isEditingMode
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditingMode {
                checkMarkLabel.text = isSelected ? "✓" : ""
            }
        }
        
    }
}
