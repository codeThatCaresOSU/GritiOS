//
//  DescriptionController.swift
//  Grit
//
//  Created by Jared Williams on 3/28/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class DescriptionController: GritSignUpController {
    
    
    private lazy var occupationField: UITextField = {
        let field = UITextField()
        
        field.textAlignment = .center
        field.placeholder = "What do you do for a living?"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 20
        
        return field
    }()
    
    private lazy var descriptionField: UITextView = {
       let field = UITextView()
        
        field.textAlignment = .left
        
        field.isEditable = true
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.cornerRadius = 20
        
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupDescriptionView()
    }
    
    func setupDescriptionView() {
        
        self.view.addSubview(self.occupationField)
        self.view.addSubview(self.descriptionField)
        
        self.leftButton.setTitle("Back", for: .normal)
        self.rightButton.setTitle("Next", for: .normal)
        
        self.descriptionLabel.text = "Tell Us\nAbout Yourself"
        
        Utility.constrain(new: self.occupationField, to: self.descriptionLabel, top: nil, bottom: 8, left: nil, right: nil, height: 50, width: self.view.frame.width - 50, centerX: true)
        
        Utility.constrain(new: self.descriptionField, to: self.occupationField, top: nil, bottom: 208, left: nil, right: nil, height: 200, width: self.view.frame.width - 50, centerX: true)
        
        
    }
    
    override func nextScreen() {
        
        if self.descriptionField.text != "" && self.occupationField.text != "" {
            self.navigationController?.pushViewController(DateSignUpController(), animated: true)
            signUpUser.description = self.descriptionField.text
            signUpUser.occupation = self.occupationField.text
        } else {
            Utility.presentGenericAlart(controller: self, title: "Oops!", message: "Looks like you forgot to fill some things out. If you don't currently have an occupation you can just type \"Seeking\"")
        }
    }
    
    
    override func lastScreen() {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
