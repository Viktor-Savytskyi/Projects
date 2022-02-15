//
//  HideKeyboard+ViewController.swift
//  ToDo List
//
//  Created by 12345 on 02.11.2021.
//

import Foundation
import UIKit

extension UIViewController {
    
    // go to the next textField after push return
    func switchBasedNextTextField(_ textField: UITextField, firstTextField: UITextField, secondTextField: UITextField) {
        switch textField {
        case firstTextField:
            secondTextField.becomeFirstResponder()
        default:
            secondTextField.resignFirstResponder()
        }
    }
    
}
