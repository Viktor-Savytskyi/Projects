//
//  ScreenToastDelegate.swift
//  Platform
//
//  Created by 12345 on 25.04.2023.
//

import Foundation

protocol ScreenToastDelegate: AnyObject {
    func showInfo(message: String, completion: (() -> Void)?)
}
