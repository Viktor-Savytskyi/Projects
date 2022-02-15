//
//  CredentialsController.swift
//  ToDo List
//
//  Created by 12345 on 23.11.2021.
//

import Foundation

class CredentialsController {
    
    var credentials: Credentials
    var expectedCredentials: Credentials = Credentials.init(email: "test@gmail.com", password: "123456789")
    
    init (credentials: Credentials) {
        self.credentials = credentials
    }
    
    func validate() throws {
        if let email = credentials.email,
           let password = credentials.password {
            if email.contains("@") {
                if password.count >= 8 {
                    //                    print("Right Format")
                } else {
                    print("Fail: password must be at least 8 symbols")
                    throw CredentialsError.lowPassword
                }
            } else {
                print("Fail: wrong email format")
                throw CredentialsError.wrongEmail
            }
        } else {
            print("Fail: empty fields")
            throw CredentialsError.emptyFields
        }
    }
    
    func checkCredentials() throws {
        if credentials.email == expectedCredentials.email && credentials.password == expectedCredentials.password {
            
        } else { throw CredentialsError.wrongCredentials }
    }
    
}

