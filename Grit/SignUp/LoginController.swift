//
//  LoginController.swift
//  Grit
//
//  Created by Jared Williams on 2/24/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class LoginController: GritSignUpController {
    
    
    private lazy var emailField: UITextField = {
       let field = UITextField()
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Your Email"
        field.keyboardType = .emailAddress
        field.textAlignment = .center
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.autocorrectionType = .no
        
        return field
    }()
    
    private lazy var passwordField: UITextField = {
       let field = UITextField()
        
        field.placeholder = "Password"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.isSecureTextEntry = true
        field.textAlignment = .center
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.autocorrectionType = .no
        return field
    }()
    
    override func viewDidLoad() {
        self.setupView()
        self.setupLoginView()
    }
    
    func setupLoginView() {
        
        self.descriptionLabel.text = "WELCOME TO\nGRIT!"
        self.rightButton.setTitle("Login", for: .normal)
        self.leftButton.setTitle("Back", for: .normal)
        
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.passwordField)
        
        Utility.constrain(new: self.emailField, to: self.descriptionLabel, top: nil, bottom: 8, left: nil, right: nil, height: 100, width: self.view.frame.width - 80, centerX: true)
        
        Utility.constrain(new: self.passwordField, to: self.emailField, top: 100, bottom: nil, left: nil, right: nil, height: 100, width: self.view.frame.width - 80, centerX: true)
    }
    
    override func lastScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func keyboardShow(notification: NSNotification) {
        let height = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect).height + 15
        
        self.emailField.frame.origin.y -= height
        self.passwordField.frame.origin.y -= height
        self.descriptionLabel.frame.origin.y -= height
        
    }
    
    override func nextScreen() {

        print("Login Pressed")
        FirebaseManager.sharedInstance.loginUser(email: emailField.text!, password: passwordField.text!) { (user: User?, error: Error?) in
            if error == nil {
                print("Error is niol")
            } else {
                Utility.presentGenericAlart(controller: self, title: error!.localizedDescription, message: error.debugDescription)
            }
        }
    }
}
