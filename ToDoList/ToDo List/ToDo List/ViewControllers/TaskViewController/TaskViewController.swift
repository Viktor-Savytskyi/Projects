//
//  TaskViewController.swift
//  ToDo List
//
//  Created by 12345 on 24.10.2021.
//

import UIKit

class TaskViewController: BaseViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextview: UITextView!
    
    var completion: ((Task)->())?
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setUiElementsConfigurations()
        shareButtonConfigurations()
    }
    
    @objc func editTextView() {
        descriptionTextview.isEditable = true
        descriptionTextview.becomeFirstResponder()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let addTaskController = AddTaskController()
        
        guard let task = try? addTaskController.createTask(name: titleTextField.text, description: descriptionTextview.text, taskDate: dateTimePicker.date) else {return}
        
        completion?(task)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
        
        if descriptionTextview.text.isEmpty {
            descriptionTextview.text = "Enter your text"
            descriptionTextview.textColor = UIColor.lightGray
        }
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyboard))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        let editTextView = UITapGestureRecognizer.init(target: self, action: #selector(editTextView))
        descriptionTextview.isUserInteractionEnabled = true
        descriptionTextview.addGestureRecognizer(editTextView)
    }
    
    func setUiElementsConfigurations() {
        titleTextField.delegate = self
        descriptionTextview.delegate = self
        descriptionTextview.font = .systemFont(ofSize: 17)

        titleTextField.setCornerRadius(radius: 12)
        descriptionTextview.setCornerRadius(radius: 12)
        descriptionTextview.text = "Enter your text"
        descriptionTextview.textColor = UIColor.lightGray
        
        dateTimePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    func shareButtonConfigurations() {
        if let task = task {
            titleTextField.text = task.title
            dateTimePicker.date = task.taskDate
            descriptionTextview.text = task.description
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if let task = task {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yy HH:mm a"
            let taskDateString = dateFormatter.string(from: task.taskDate)
            
            let activityViewController = UIActivityViewController(activityItems: [task.title, taskDateString, task.description], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextview.textColor == UIColor.lightGray {
            descriptionTextview.text = nil
            descriptionTextview.textColor = UIColor.black
        }
    }
    
}

