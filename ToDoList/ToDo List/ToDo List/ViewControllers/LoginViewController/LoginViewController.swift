//
//  ViewController.swift
//  ToDo List
//
//  Created by 12345 on 10.10.2021.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var applicationImage: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiElementsConfigurations()
        navigationController?.navigationBar.isHidden = true
    }
    
    // hide the keyboard when tapping on the screen (outside the keyboard area)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier != "fromLoginToTaskList" {
            return true
        }
        
        let credentialsController = CredentialsController(credentials: Credentials(email: emailTextField.text, password: passwordTextField.text))
        
        do {
            try credentialsController.validate()
            try credentialsController.checkCredentials()
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            return true
        } catch {
            resultLabel.text = ((error as! CredentialsError).description)
            return false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool else {return}
        if isLoggedIn {
            performSegue(withIdentifier: "fromLoginToTaskList", sender: self)
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        print("loginAction")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
        
        // go to the next textField after push return
        self.switchBasedNextTextField(textField, firstTextField: emailTextField, secondTextField: passwordTextField)
    }
    
    func uiElementsConfigurations() {
        emailTextField.setCornerRadius(radius: 12)
//        emailTextField.layer.borderWidth = 2
//        emailTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        
        passwordTextField.setCornerRadius(radius: 12)
//        passwordTextField.layer.borderWidth = 2
//        passwordTextField.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        
        loginButton.setCornerRadius(radius: 12)

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}

