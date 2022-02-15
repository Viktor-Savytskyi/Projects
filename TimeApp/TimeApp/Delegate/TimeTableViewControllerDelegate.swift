//
//  File.swift
//  TimeApp
//
//  Created by 12345 on 01.12.2021.
//

import Foundation

protocol TimeTableViewControllerDelegate {
    func didLabelChanged(with text: String, indexPath: IndexPath) 
}
