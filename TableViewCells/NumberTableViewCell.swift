//
//  NumberTableViewCell.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/22/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit
import Firebase

class NumberTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let numbers: [Int] = [1, 2, 3, 4, 5]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("User picked \"\(numbers[row])\"")
        //mainInstance.defaults.set(numbers[row], forKey: "numberOfMentees")
       // if let user = Auth.auth().currentUser { FirebaseVars.ref.child("Users").child(user.uid).child("Settings").child("numberOfMentees").setValue(numbers[row])
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
            /**FirebaseVars.ref.child("Users").child(user.uid).child("Settings").child("numberOfMentees").observe(.value, with: { snapshot  in
                let number = snapshot.value as! Int
                switch number {
                case 1:
                    myPicker.selectRow(0, inComponent: 0, animated: true)
                case 2:
                    myPicker.selectRow(1, inComponent: 0, animated: true)
                case 3:
                    myPicker.selectRow(2, inComponent: 0, animated: true)
                case 4:
                    myPicker.selectRow(3, inComponent: 0, animated: true)
                case 5:
                    myPicker.selectRow(4, inComponent: 0, animated: true)
                default:
                    print("Error in database (numberOfMentees).")
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
