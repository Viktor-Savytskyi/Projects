//
//  ScreenAlertDelegate.swift
//  Platform
//
//  Created by 12345 on 10.04.2023.
//

import Foundation

protocol ScreenAlertDelegate: AnyObject {
    func showAlert(error: String, completion: (() -> Void)?)
}

//extension ScreenAlertDelegate {
//    func showAlert(error: String, completion: (() -> Void)? = nil) { }
//}
