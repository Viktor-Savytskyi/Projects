//
//  RegistrationViewController.swift
//  ToDo List
//
//  Created by 12345 on 19.10.2021.
//

import UIKit


class RegistrationViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var registrationEmailTextField: UITextField!
    @IBOutlet weak var registrationPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiElementsConfigurations()
        navigationBarConfigurations()
    }
    
    // hide the keyboard when tapping on the screen (outside the keyboard area)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let credentialsController = CredentialsController(credentials: Credentials(email: registrationEmailTextField.text, password: registrationPasswordTextField.text))
        
        do {
            try credentialsController.validate()
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            return true
        } catch {
            print((error as! CredentialsError).description)
            return false
        }
    }
    
    @IBAction func registrationAction(_ sender: Any) {
        //        print("Registration action")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
        
//        go to the next textField after push return
        self.switchBasedNextTextField(textField, firstTextField: registrationEmailTextField, secondTextField: registrationPasswordTextField)
    }
    
    func uiElementsConfigurations() {
        registrationEmailTextField.setCornerRadius(radius: 12)
        registrationPasswordTextField.setCornerRadius(radius: 12)
        registrationButton.setCornerRadius(radius: 12)
        
        registrationEmailTextField.delegate = self
        registrationPasswordTextField.delegate = self
    }
    
    func navigationBarConfigurations() {
        navigationController?.navigationBar.isHidden = false
    }
}
