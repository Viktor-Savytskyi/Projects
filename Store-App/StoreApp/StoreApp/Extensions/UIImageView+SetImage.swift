//
//  UIImageView+SetImage.swift
//  StoreApp
//
//  Created by 12345 on 26.01.2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(url: String) {
        let url = URL(string: url)
        kf.setImage(with: url)
    }
}
