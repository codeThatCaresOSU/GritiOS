//
//  User.swift
//  GRIT
//
//  Created by Jared Williams on 9/24/17.
//  Copyright © 2017 CodeThatCares. All rights reserved.
//
import Foundation


class User {
    var email: String!
    var password: String!
    
    var firstName: String!
    var lastName: String!
    
    var age: String!
    var description: String!
    
    var uid: String!
    var mentorStatus: MentorStatus!
    
    var gender: Sex!
    
    var occupation: String!
    var savedResources: [String : String]?
    
    init(email: String, password: String!) {
        self.email = email
        self.password = password
    }
    
    init() {
        
    }
}

public enum MentorStatus: Int {
    case Mentor = 1
    case Mentee = 0
}

public enum Sex: String {
    case Male = "Male"
    case Female = "Female"
}
