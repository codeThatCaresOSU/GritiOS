//
//  ModalViewController.swift
//  GRIT
//
//  Created by Jake Alvord on 10/19/17.
//  Copyright © 2017 CodeThatCares. All rights reserved.
//
import UIKit

protocol ModalViewControllerDelegate{
    func dismissFilter(modalText: Array<String>)
}

class ModalViewController: UIViewController {
    
    var delegate: ModalViewControllerDelegate! = nil
    
    // button names and images
    let categories = ["Food", "G.E.D", "Recovery", "Second Chance Employer", "Transportation"]
    let names = ["Food", "G.E.D", "Recovery", "Employers", "Transportation"]
    let cellImages = [#imageLiteral(resourceName: "food"), #imageLiteral(resourceName: "diploma"), #imageLiteral(resourceName: "refresh"), #imageLiteral(resourceName: "humans"), #imageLiteral(resourceName: "bus")]
    
    // button colors
    let buttonColor = UIColor(rgb: 0xD51A40)
    let filterColor = UIColor(rgb: 0x2CD4F2)
    
    // buttons
    var buttonIcons = [UIButton]()
    var buttonLabels = [UIButton]()
    
    // collections
    var buttons = [UIButton]()
    var fields = [String]()
    
    override func viewDidLoad() {
        
        // gets standard heights and widths
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let width = self.view.bounds.width
        let height = self.view.bounds.height - statusBarHeight
        
        // sets background blur
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // adds the blurred view as background
        self.view.addSubview(blurView)
        
        buttonSetUp(width: width, height: height)
 
    }
    
    func buttonSetUp(width: CGFloat, height: CGFloat) {
        
        // heights and lengths
        let cellHeight = height/CGFloat(categories.count + 1)
        let cellCount = categories.count + 1
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let inset = cellHeight/6
        
        for i in 0...cellCount {
         
            if i < cellCount - 1 {
                
                // set up of icons on left
                let iconButton = UIButton()
                iconButton.frame = CGRect(x: inset, y: statusBarHeight + inset + CGFloat(i) * cellHeight, width: cellHeight - inset, height: cellHeight - inset)
                iconButton.setImage(cellImages[i], for: .normal)
                iconButton.layer.cornerRadius = (cellHeight - inset)/2
                iconButton.layer.masksToBounds = true
                iconButton.backgroundColor = buttonColor
                iconButton.imageEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
                iconButton.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
                
                // set up of labels on right
                let iconLabel = UIButton()
                iconLabel.frame = CGRect(x: cellHeight + inset, y: inset + statusBarHeight + CGFloat(i) * cellHeight, width: width - cellHeight - inset, height: cellHeight - inset)
                iconLabel.setTitle(names[i], for: .normal)
                iconLabel.setTitleColor(UIColor.white, for: .normal)
                iconLabel.contentHorizontalAlignment = .left
                iconLabel.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: UIFont.Weight.thin)
                iconLabel.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
                
                // compilation of buttons and labels
                buttonIcons.append(iconButton)
                buttonLabels.append(iconLabel)
                
                // adding buttons and labels to view
                self.view.addSubview(iconButton)
                self.view.addSubview(iconLabel)
                
            } else {
                
                // set up of filter button on bottom
                let filterButton = UIButton()
                filterButton.frame = CGRect(x: width/8, y: statusBarHeight + inset + CGFloat(i) * cellHeight, width: (3 * width)/4, height: cellHeight/2)
                filterButton.backgroundColor = filterColor
                filterButton.layer.cornerRadius = filterButton.bounds.height/8
                filterButton.layer.masksToBounds = true
                filterButton.setTitle("Filter", for: .normal)
                filterButton.setTitleColor(UIColor.white, for: .normal)
                filterButton.addTarget(self, action: #selector(dismissFilter), for: .touchUpInside)
                
                // adding filterButton to view
                self.view.addSubview(filterButton)
                
            }
            
        }
        
    }
    
    @objc func buttonTapped(button: UIButton) {
        
        if buttonIcons.contains(button) {
            
            if button.backgroundColor == buttonColor {
                button.backgroundColor = UIColor.lightGray
            } else if button.backgroundColor == UIColor.lightGray {
                button.backgroundColor = buttonColor
            }
            
        } else {
            
            let buttonSpot = (buttonLabels.index(of: button))!
            
            if buttonIcons[buttonSpot].backgroundColor! == buttonColor {
                buttonIcons[buttonSpot].backgroundColor = UIColor.lightGray
            } else if buttonIcons[buttonSpot].backgroundColor == UIColor.lightGray {
                buttonIcons[buttonSpot].backgroundColor = buttonColor
            }
            
        }
        
    }
    
    func compileFields() {
        
        fields.removeAll()
        
        for i in 0...categories.count - 1 {
            if buttonIcons[i].backgroundColor == UIColor.lightGray {
                fields.append(categories[i])
            }
        }
        
    }
    
    @objc func dismissFilter() {
        compileFields()
        self.delegate.dismissFilter(modalText: fields)
    }
    
}
