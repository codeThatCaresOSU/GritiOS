//
//  Message.swift
//  Grit
//
//  Created by Frank  on 3/28/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    // To-Do update the schema, maybe create a init function?
    
    init(values: [String: Any]) {
        self.fromId = values["fromId"] as? String
        self.toId = values["toId"] as? String
        self.text = values["text"] as? String
        self.timestamp = values["timestamp"] as? NSNumber
    }
    
    // returns recipient of a chat message
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        } else {
            return fromId
        }
    }
}
