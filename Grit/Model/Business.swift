//
//  Business.swift
//  GRIT
//
//  Created by Jake Alvord on 10/22/17.
//  Copyright © 2017 CodeThatCares. All rights reserved.
//
import Foundation


struct Business: Codable {
    var name: String!
    var category: String!
    var street: String!
    var city: String!
    var state: String!
    var zip: String!
    var url: String!
    var phone: String!
    var id: String!
    var lat: Double?
    var lng: Double?
    
    init() {
        
    }
}
