//
//  ChangePasswordViewController.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/4/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    
    var oldPasswordEntered: String = ""
    var oldPasswordLabel = UILabel()
    var oldPasswordTextField = UITextField()
    var newPasswordLabel = UILabel()
    var newPasswordTextField = UITextField()
    var newPasswordEntered: String = ""
    var confirmPasswordLabel = UILabel()
    var confirmPasswordTextField = UITextField()
    var confirmPasswordEntered: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize View Controller
        self.view.backgroundColor = colorScheme.backgroundColor
        self.title = "Change Password"
        
        oldPasswordLabel = createLabel(text: "Old password:")
        oldPasswordTextField = createTextField(text: "Enter old password")
        newPasswordLabel = createLabel(text: "New password:")
        newPasswordTextField = createTextField(text: "Enter new password")
        confirmPasswordLabel = createLabel(text: "Confirm password:")
        confirmPasswordTextField = createTextField(text: "Confirm new password")
        addConstraints()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = colorScheme.textColor
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = fonts.headerFont
        self.view.addSubview(label)
        return label
    }
    
    func createTextField(text: String) -> UITextField {
        let textField = UITextField()
        textField.delegate = self
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.autocorrectionType = .no
        textField.textColor = colorScheme.textColor
        textField.font = fonts.textFont
        textField.backgroundColor = colorScheme.whiteColor
        textField.placeholder = text
        textField.keyboardType = .alphabet
        if text == "Confirm new password"{
            textField.returnKeyType = .done
        } else {
            textField.returnKeyType = .next
        }
        textField.isSecureTextEntry = true
        self.view.addSubview(textField)
        return textField
    }
    
    func addConstraints() {
        // Label constraints
        let textHeight: CGFloat = 20
        let leftMargin: CGFloat = 15
        let topMargin: CGFloat = 30
        
        // Text field constraints
        let rightMargin: CGFloat = -15
        
        oldPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordLabel.heightAnchor.constraint(equalToConstant: textHeight).isActive = true
        oldPasswordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftMargin).isActive = true
        oldPasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: topMargin).isActive = true
        oldPasswordLabel.widthAnchor.constraint(equalToConstant: confirmPasswordLabel.intrinsicContentSize.width).isActive = true
        
        newPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        newPasswordLabel.heightAnchor.constraint(equalToConstant: textHeight).isActive = true
        newPasswordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftMargin).isActive = true
        newPasswordLabel.topAnchor.constraint(equalTo: oldPasswordLabel.bottomAnchor, constant: topMargin).isActive = true
        newPasswordLabel.widthAnchor.constraint(equalToConstant: confirmPasswordLabel.intrinsicContentSize.width).isActive = true
        
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints  = false
        confirmPasswordLabel.heightAnchor.constraint(equalToConstant: textHeight).isActive = true
        confirmPasswordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: leftMargin).isActive = true
        confirmPasswordLabel.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: topMargin).isActive = true
        confirmPasswordLabel.widthAnchor.constraint(equalToConstant: confirmPasswordLabel.intrinsicContentSize.width).isActive = true
        
        oldPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        oldPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightMargin).isActive = true
        oldPasswordTextField.leadingAnchor.constraint(equalTo: oldPasswordLabel.trailingAnchor, constant: leftMargin).isActive = true
        oldPasswordTextField.centerYAnchor.constraint(equalTo: oldPasswordLabel.centerYAnchor).isActive = true
        oldPasswordTextField.widthAnchor.constraint(equalTo: newPasswordTextField.widthAnchor).isActive = false
        
        newPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        newPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightMargin).isActive = true
        newPasswordTextField.leadingAnchor.constraint(equalTo: newPasswordLabel.trailingAnchor, constant: leftMargin).isActive = true
        newPasswordTextField.centerYAnchor.constraint(equalTo: newPasswordLabel.centerYAnchor).isActive = true
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: rightMargin).isActive = true
        confirmPasswordTextField.leadingAnchor.constraint(equalTo: confirmPasswordLabel.trailingAnchor, constant: leftMargin).isActive = true
        confirmPasswordTextField.centerYAnchor.constraint(equalTo: confirmPasswordLabel.centerYAnchor).isActive = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == oldPasswordTextField {
            oldPasswordEntered = textField.text!
            print("Old Password: \(oldPasswordEntered)")
        }
        else if textField == newPasswordTextField {
            newPasswordEntered = textField.text!
            print("New Password: \(newPasswordEntered)")
        }
        else if textField == confirmPasswordTextField {
            confirmPasswordEntered = textField.text!
            print("Re-entered new password: \(confirmPasswordEntered)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let email = Auth.auth().currentUser?.email
        if textField == oldPasswordTextField {
            textField.resignFirstResponder()
            newPasswordTextField.becomeFirstResponder()
        } else if textField == newPasswordTextField {
            textField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            textField.resignFirstResponder()
            
            if newPasswordEntered == confirmPasswordEntered && email != nil{
                // CALL CHANGE PASSWORD METHOD
                changePassword(email: email!, oldPW: oldPasswordEntered, newPW: confirmPasswordEntered)
            } else {
                print("passwords do not match")
            }
        
            
        }
        return true
    }
    
    /* func passwordAlert() {
     
     let alert = UIAlertController(title: "Error!", message: msg, preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
     self.present(alert, animated: true, completion: nil)
     
     
     changePassword(newPW: newPasswordEntered)
     let alert = UIAlertController(title: "Success!", message: "Password has been changed to \(oldPassword!)", preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
     self.present(alert, animated: true, completion: nil)
     }
     */
    
    func changePassword(email: String, oldPW: String, newPW: String){
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: oldPW)
        
        user?.reauthenticate(with: credential, completion: { (error) in
            if error != nil{
                print("Error reauthenticating user")
            }else{
                Auth.auth().currentUser?.updatePassword(to: newPW) { (error) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("password changed to: \(newPW)")
                    }
                }
            }
        })
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
