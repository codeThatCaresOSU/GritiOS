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
//    
//    init(values: [String: Any]) {
//        
//    }
    
    func chatPartnerId() -> String? {
        // fixes bug and sets the correct recipient
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        } else {
            return fromId
        }
    }
}
