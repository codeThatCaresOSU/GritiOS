//
//  ChatUser.swift
//  Grit
//
//  Created by Frank  on 3/28/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class ChatUser: NSObject {
    // To-Do update with new schema
    @objc var name: String?
    @objc var email: String?
    // set to a constant for now...
    @objc var profileImageUrl: String?
    @objc var id: String?
    @objc var isMentor: String?
    
    init(values: [String:Any]) {
        let firstName = values["firstName"] as? String
        let lastName = values["lastName"] as? String
        if let fName = firstName, let lName = lastName {
            self.name = "" + fName + lName
        }
        self.email = values["email"] as? String
        self.profileImageUrl = values["profileImageUrl"] as? String
        self.isMentor = values["isMentor"] as? String
    }
    
    override init() {
        // no argument constructor for testing purposes only
    }
}

