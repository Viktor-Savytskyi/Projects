//
//  UpdateViewControllerUI.swift
//  Platform
//
//  Created by 12345 on 09.04.2023.
//

import Foundation

protocol UpdateScreenDelegate: AnyObject {
    func showScreenLoader()
    func showAlert(error: String)
    func hideScreenLoader()
}
