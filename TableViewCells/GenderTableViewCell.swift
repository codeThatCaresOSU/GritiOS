//
//  GenderTableViewCell.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/21/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit
import Firebase

class GenderTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let genders: [String] = ["Male", "Female", "Both"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("User picked \"\(genders[row])\"")
        //if let user = Auth.auth().currentUser { FirebaseVars.ref.child("Users").child(user.uid).child("Settings").child("genderOfMentees").setValue(genders[row])
        //}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.backgroundColor = colorScheme.backgroundColor
        self.textLabel?.font = fonts.textFont
        self.textLabel?.textColor = colorScheme.textColor
        self.layer.borderWidth = cellFormats.cellBorderSize
        self.layer.borderColor = colorScheme.headerColor.cgColor
        let myPicker = UIPickerView()
        myPicker.delegate = self
        myPicker.dataSource = self
        myPicker.showsSelectionIndicator = true
        
        if let user = Auth.auth().currentUser {
            /**FirebaseVars.ref.child("Users").child(user.uid).child("Settings").child("genderOfMentees").observe(.value, with: { snapshot  in
                let gender = snapshot.value as! String
                switch gender {
                case "Male":
                    myPicker.selectRow(0, inComponent: 0, animated: true)
                case "Female":
                    myPicker.selectRow(1, inComponent: 0, animated: true)
                case "Both":
                    myPicker.selectRow(2, inComponent: 0, animated: true)
                default:
                    print("Error in database (genderOfMentees)")
                }
            }) **/
        }
        
        self.addSubview(myPicker)
        myPicker.translatesAutoresizingMaskIntoConstraints = false
        myPicker.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        myPicker.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        myPicker.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        myPicker.widthAnchor.constraint(equalToConstant: 150).isActive = true
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}