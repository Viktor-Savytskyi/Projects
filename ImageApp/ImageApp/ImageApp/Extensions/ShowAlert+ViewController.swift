//
//  ShowAllert+ViewController.swift
//  Advisor
//
//  Created by 12345 on 17.08.2021.
//

import UIKit

extension UIViewController  {
    
    func showAlert(title: String, message: String, okTitle: String = "Try again", okAction:((UIAlertAction) -> Void)?, cancelTitle: String = "Cancel") {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: okTitle, style: .default, handler: okAction)
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    }
}
