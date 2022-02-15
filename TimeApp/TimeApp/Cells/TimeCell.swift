//
//  TimeCell.swift
//  TimeApp
//
//  Created by 12345 on 30.07.2021.
//

import UIKit

class TimeCell: UITableViewCell {
    
    @IBOutlet weak var timeCellLbl: UILabel!
    @IBOutlet weak var textCellLbl: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    var complation: ((Bool)->())?
    
    func fill(model: Element) {
        timeCellLbl.text = model.time
        textCellLbl.text = model.text
        selectButton.isSelected = model.status
    }
    
    @IBAction func selectAction(_ sender: Any) {
        complation?(selectButton.isSelected)
    }
}
