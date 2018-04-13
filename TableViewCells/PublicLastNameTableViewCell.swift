//
//  PublicLastNameTableViewCell.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/22/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit
import Firebase

class PublicLastNameTableViewCell: UITableViewCell {

    var myConstraints: [NSLayoutConstraint] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Customize cell
        self.selectionStyle = .none
        self.backgroundColor = colorScheme.backgroundColor
        self.textLabel?.textColor = colorScheme.textColor
        self.textLabel?.font = fonts.textFont
        self.layer.borderWidth = cellFormats.cellBorderSize
        self.layer.borderColor = colorScheme.headerColor.cgColor
        
        // Create switch
        let mySwitch = createNotificationSwitch()
        self.addSubview(mySwitch)
        
        // Constraints
        mySwitch.translatesAutoresizingMaskIntoConstraints = false
        let yPlacement = mySwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        let rightConstraint = mySwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        
        myConstraints = [yPlacement, rightConstraint]
        NSLayoutConstraint.activate(myConstraints)
    }
    
    @objc func switchChanged(sender: UISwitch!){
        print("Switch value is \(sender.isOn)")
        // Turn off notifications
        
        if let user = Auth.auth().currentUser {
            //sender.isOn ? FirebaseVars.ref.child("Users").child(user.uid).child("Settings").child("lastNameVisible").setValue(true) : FirebaseVars.ref.child("Users").child(user.uid).child("Settings").child("lastNameVisible").setValue(false)
        }
    }
    
    func createNotificationSwitch() -> UISwitch {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .green
        mySwitch.tintColor = .black
        mySwitch.backgroundColor = .red;
        mySwitch.layer.cornerRadius = 16.0;
        mySwitch.thumbTintColor = .black
        mySwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
        
        if let user = Auth.auth().currentUser {
//            FirebaseVars.ref.child("Users").child(user.uid).child("Settings").child("lastNameVisible").observe(.value, with: { snapshot  in
//                let isVisible = snapshot.value as! Bool
//                mySwitch.setOn(isVisible, animated: true)
//            })
        }
        
        return mySwitch
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
