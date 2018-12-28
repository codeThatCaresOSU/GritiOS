//
//  Global.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/14/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import Foundation
import UIKit


struct globalVars {
    let defaults = UserDefaults.standard
}
class Main {
    var defaults: UserDefaults
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}
var mainInstance = Main(defaults: UserDefaults.standard)

struct colorScheme {
    static let backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    static let barColor = UIColor(red:0.36, green:0.72, blue:0.36, alpha:1.0)
    static let headerColor = UIColor(red:0.36, green:0.72, blue:0.72, alpha:1.0)
    static let buttonColor = UIColor(red:0.03, green:0.22, blue:0.24, alpha:1.0)
    static let textColor = UIColor(red:0.04, green:0.04, blue:0.05, alpha:1.0)
    static let whiteColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
}

struct fonts {
    static let headerFont = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
    static let textFont = UIFont(name: "HelveticaNeue", size: 18.0)
}
struct cellFormats {
    static let cellBorderSize: CGFloat = 1.0
    static let headerHeight: CGFloat = 60
    static let leftHeaderPadding: CGFloat = 20
    static let cellHeight: CGFloat = 50
    static let cellHeightMentor: CGFloat = 75
}
