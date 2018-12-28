//
//  NotificationsTableViewCell.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/4/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {

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
        mySwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mySwitch.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
    }

    @objc func switchChanged(sender: UISwitch!){
        print("Switch value is \(sender.isOn)")
        // Turn off notifications
        if sender.isOn {
            mainInstance.defaults.set(true, forKey: "notifications")
        } else {
            mainInstance.defaults.set(false, forKey: "notifications")
        }
    }
    
    func createNotificationSwitch() -> UISwitch{
        
        let mySwitch = UISwitch()
        mySwitch.setOn(mainInstance.defaults.bool(forKey: "notifications"), animated: true)
        mySwitch.onTintColor = .green
        mySwitch.tintColor = .black
        mySwitch.backgroundColor = .red
        mySwitch.layer.cornerRadius = 16.0
        mySwitch.layer.masksToBounds = true
        mySwitch.thumbTintColor = .black
        mySwitch.addTarget(self, action: #selector(switchChanged(sender:)), for: UIControlEvents.valueChanged)
        
        return mySwitch
    }
}
