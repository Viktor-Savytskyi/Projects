//
//  EditingViewController.swift
//  TimeApp
//
//  Created by 12345 on 07.11.2021.
//

import Foundation
import UIKit


class EditingViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var changeTextView: UITextView!
    
    var timeTableViewControllerDelegate: TimeTableViewControllerDelegate?
    var indexPath: IndexPath!
    var currentElement: Element?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenUiConfigurations()
        setTapGesture()
        setNavigationBarConfigurations()
    }
    
    func screenUiConfigurations() {
        changeTextView.delegate = self
        changeTextView.text = currentElement?.text
        changeTextView.setCornerRadius(radius: 15)
        changeTextView.becomeFirstResponder()
    }
    
    func setNavigationBarConfigurations() {
        // setup white color for navBar items
        navigationController?.navigationBar.tintColor = .white
        // set navTitle font style and white color
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.title = currentElement?.time
        
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .save, target: self, action: #selector(saveComment))
    }
    
    @objc func saveComment(_ textView: UITextView) {
        timeTableViewControllerDelegate?.didLabelChanged(with: changeTextView.text!, indexPath: indexPath)
        navigationController?.popViewController(animated: true)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
       
        textView.resignFirstResponder()
        return true
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
    }
        
    @objc func endEditing() {
        view.endEditing(true)
    }
    
}
