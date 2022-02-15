//
//  UIview+cornerRadius.swift
//  TimeApp
//
//  Created by 12345 on 03.12.2021.
//

import Foundation
import UIKit

extension UIView {
    
    func setCornerRadius(radius: CGFloat) {
       layer.cornerRadius = radius
       layer.masksToBounds = true
    }
}
