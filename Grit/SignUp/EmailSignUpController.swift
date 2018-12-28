//
//  EmailSignUpController.swift
//  Grit
//
//  Created by Jared Williams on 2/25/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class EmailSignUpController: GritSignUpController {
    
    private var emailField: UITextField = {
       let field = UITextField()
        
        field.placeholder = "Email"
        field.textAlignment = .center
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.keyboardType = .emailAddress
        field.adjustsFontSizeToFitWidth = true
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    private var passwordField: UITextField = {
        let field = UITextField()
        
        field.placeholder = "Password"
        field.textAlignment = .center
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        
        return field
    }()
    
    override func viewDidLoad() {
        self.setupView()
        self.setupEmailView()
    }
    
    func setupEmailView() {
        self.descriptionLabel.numberOfLines = 3
        self.descriptionLabel.text = "EMAIL\nAND\nPASSWORD"
        
        self.leftButton.setTitle("Back", for: .normal)
        self.rightButton.setTitle("Next", for: .normal)
        
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        
        Utility.constrain(new: self.emailField, to: self.descriptionLabel, top: nil, bottom: self.emailField.frame.height + 108, left: nil, right: nil, height: 50, width: self.view.frame.width - 60, centerX: true)
        
         Utility.constrain(new: self.passwordField, to: self.emailField, top: self.emailField.frame.height + 40, bottom: nil, left: nil, right: nil, height: 50, width: self.view.frame.width - 60, centerX: true)
        
    }
    
    override func nextScreen() {
        
        if self.emailField.text! != "" && self.passwordField.text! != ""{
            
            signUpUser.email = self.emailField.text!
            signUpUser.password = self.passwordField.text!
            
            self.navigationController?.pushViewController(NameController(), animated: true)
        } else {
            Utility.presentGenericAlart(controller: self, title: "Oops!", message: "Looks like you forgot to fill out some information")
        }
        
    }
    
    override func lastScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
