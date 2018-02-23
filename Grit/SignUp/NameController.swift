//
//  NameController.swift
//  Grit
//
//  Created by Jared Williams on 2/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class NameController: GritSignUpController {
    
    lazy var firstNameField: UITextField = {
       let field = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        field.textAlignment = .center
        field.placeholder = "First Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.isUserInteractionEnabled = true
        field.addUnderline()
        
        return field
    }()
    
    lazy var lastNameField: UITextField = {
        
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        field.textAlignment = .center
        field.placeholder = "Last Name"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.isUserInteractionEnabled = true
        field.addUnderline()
        
        return field
    }()
    
    lazy var zipCodeField: UITextField = {
       
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        field.textAlignment = .center
        field.placeholder = "Zip Code"
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.isUserInteractionEnabled = true
        field.addUnderline()
        return field
        
    }()

    
    override func viewDidLoad() {
        self.setupView()
        self.setupNameView()
    }
    
    func setupNameView() {
        self.view.backgroundColor = .white
        self.descriptionLabel.text = "We Just Need\nA Little Info"
        
        self.leftButton.setTitle("Back", for: .normal)
        self.rightButton.setTitle("Next", for: .normal)
        
        self.view.addSubview(self.firstNameField)
        self.view.addSubview(self.lastNameField)
        self.view.addSubview(self.zipCodeField)
        
        Utility.constrain(new: self.firstNameField, to: self.view, top: nil, bottom: nil, left: nil, right: nil, height: 100, width: self.view.frame.width - 20, centerX: true)
        Utility.constrain(new: self.firstNameField, to: self.descriptionLabel, top: nil, bottom: 8, left: nil, right: nil, height: nil, width: nil, centerX: false)
        
        Utility.constrain(new: self.lastNameField, to: self.firstNameField, top: nil, bottom: 75, left: nil, right: nil, height: 100, width: self.view.frame.width - 20, centerX: true)
        
        Utility.constrain(new: self.zipCodeField, to: self.lastNameField, top: nil, bottom: 75, left: nil, right: nil, height: 100, width: self.view.frame.width - 20, centerX: true)
    }
    
    override func nextScreen() {
        self.navigationController?.pushViewController(MentorMenteeSignupController(), animated: true)
    }
}
