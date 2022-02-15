//
//  BaseViewController.swift
//  ToDo List
//
//  Created by 12345 on 19.10.2021.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()

    }
    
    func setColor() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]    }

}
