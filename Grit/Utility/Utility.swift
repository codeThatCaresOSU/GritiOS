//
//  Utility.swift
//  SoundMap6
//
//  Created by Jared Williams on 1/20/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Utility {
    
    
    
    /***
     
     Creates a navigation controller with the specified root view controller, tab bar controller title, navigation title, bar buttons, and bar tint color
     
     **/
    
    static func createNavigationController(title: String, controller: UIViewController, buttons: [UIBarButtonItem]?, color: UIColor, tabTitle: String, textColor: UIColor) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: controller)
        nav.navigationBar.topItem?.title = title
        nav.navigationBar.barTintColor = color
        nav.tabBarItem.title = tabTitle
        nav.navigationBar.prefersLargeTitles = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : textColor]
        
        if let barButtons = buttons {
            if barButtons.count % 2 == 0 {
                let leftButtons = barButtons[0..<(barButtons.count / 2)]
                nav.navigationBar.topItem?.leftBarButtonItems = Array(leftButtons)
                
                let rightButtons = barButtons[ (barButtons.count / 2) ..< barButtons.count]
                nav.navigationBar.topItem?.rightBarButtonItems = Array(rightButtons)
                
            } else {
                let rightCount = barButtons.count / 2
                let leftCount = barButtons.count - rightCount
                
                let leftButtons = barButtons.dropFirst(leftCount)
                let rightButtons = barButtons.dropLast(rightCount)
                
                nav.navigationBar.topItem?.leftBarButtonItems = Array(leftButtons)
                nav.navigationBar.topItem?.rightBarButtonItems = Array(rightButtons)
                
            }
        }
        
        return nav
    }
}

extension UICollectionViewCell {
    func addShadow() {
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: self.layer.cornerRadius).cgPath
    }
}

extension UIButton {
    func addShadow() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
}

extension String {
    func truncate(to length: Int) -> String {
        return String(self.prefix(length))
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


//
//  Utility.swift
//  Grit
//
//  Created by Jared Williams on 2/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//


