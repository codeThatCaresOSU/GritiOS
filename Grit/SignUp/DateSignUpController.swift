//
//  DateSignUpController.swift
//  Grit
//
//  Created by Jared Williams on 2/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class DateSignUpController: GritSignUpController {
    
    
    lazy var dateField: UITextField = {
        let field = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        field.textAlignment = .center
        field.placeholder = "Your Birthdate"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.boldSystemFont(ofSize: 30)
        field.isUserInteractionEnabled = true
        field.addUnderline()
        
        return field
    }()
    
    lazy var datePicker: UIDatePicker = {
       let picker = UIDatePicker()
        picker.setDate(Date(), animated: true)
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
        picker.maximumDate = Date()
        return picker
    }()
    
    override func viewDidLoad() {
        self.setupView()
        self.setupDateView()
    }
    
    func setupDateView() {
        
        self.leftButton.setTitle("Back", for: .normal)
        self.rightButton.setTitle("Next", for: .normal)
        
        self.descriptionLabel.numberOfLines = 2
        self.descriptionLabel.text = "WHEN WERE\nYOU BORN?"
        
        self.dateField.inputView = self.datePicker
        
        self.view.addSubview(self.dateField)
        
        Utility.constrain(new: self.dateField, to: self.view, top: 300, bottom: nil, left: nil, right: nil, height: 100, width: self.view.frame.width - 20, centerX: true)
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignResponder)))
    }
    
    @objc func dateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        
        self.dateField.text = dateFormatter.string(from: self.datePicker.date)
    }
    
    override func keyboardShow(notification: NSNotification) {
        let height = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect).height
        
        self.dateField.frame.origin.y -= height
        self.descriptionLabel.frame.origin.y -= height
    }
    
    @objc func resignResponder() {
        self.view.subviews.forEach() {
            if $0 is UITextField {
                $0.resignFirstResponder()
               
            }
        }
    }
    
    override func nextScreen() {
        
        if !self.dateField.text!.isEmpty {
            self.navigationController?.pushViewController(AllDoneSignUpController(), animated: true)
        } else {
            Utility.presentGenericAlart(controller: self, title: "Oops!", message: "Looks like you forgot to fill out some info")
        }
    }
}
