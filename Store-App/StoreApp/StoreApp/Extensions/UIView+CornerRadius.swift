//
//  UIView+CornerRadius.swift
//  StoreApp
//
//  Created by 12345 on 23.01.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func setCornerRadius(by number: Int) {
        layer.cornerRadius = CGFloat(number)
        clipsToBounds = true
    }
}
