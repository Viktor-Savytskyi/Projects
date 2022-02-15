//
//  UIViewController+Allert.swift
//  WeatherApp
//
//  Created by 12345 on 13.02.2022.
//

import Foundation
import UIKit

extension WeatherViewModel {
    
    func showAlert(title: String, message: String, buttonTitle: String, action: @escaping (UIAlertAction)->()) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let someAction = UIAlertAction(title: buttonTitle, style: .default, handler: action)
        alertController.addAction(someAction)
        return alertController
    }
    
}
