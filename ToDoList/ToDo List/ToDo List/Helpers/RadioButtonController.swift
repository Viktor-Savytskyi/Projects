//
//  RadioButton.swift
//  ToDo List
//
//  Created by 12345 on 23.12.2021.
//

import Foundation
import UIKit

class RadioButtonController: NSObject {
    var buttonsArray: [UIButton]!
    var selectedButton: UIButton?
    var defaultButton: UIButton = UIButton() {
        didSet {
            buttonArrayUpdated(buttonSelected: self.defaultButton)
        }
    }
    
    func buttonArrayUpdated(buttonSelected: UIButton) {
        for button in buttonsArray {
            if button == buttonSelected {
                selectedButton = button
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
  
}
