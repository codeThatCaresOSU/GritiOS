//
//  ModalViewController.swift
//  GRIT
//
//  Created by Jake Alvord on 10/19/17.
//  Copyright © 2017 CodeThatCares. All rights reserved.
//
import UIKit

protocol ModalControllerDelegate{
    func dismissFilter(modalText: Array<String>)
}

class BarButton : UIButton {
    var iconButton : UIButton? = nil
    var labelButton : UIButton? = nil
}

class ModalController: UIViewController {
    
    var modalDelegate: ModalControllerDelegate! = nil
    
    let foodButton = UIButton()
    let employerButton = UIButton()
    let recoveryButton = UIButton()
    let gedButton = UIButton()
    let transportButton = UIButton()
    
    let icons = [#imageLiteral(resourceName: "food"), #imageLiteral(resourceName: "humans"), #imageLiteral(resourceName: "refresh"), #imageLiteral(resourceName: "diploma"), #imageLiteral(resourceName: "bus")]
    let iconLabels = ["Food", "Employers", "Recovery", "G.E.D", "Transportation"]
    let realLabels = ["Food", "Second Chance Employer", "Recovery", "G.E.D.", "Transportation"]
    var buttons : [UIButton] = []
    var spot = -1

    let buttonColor = UIColor.init(red: 0.82, green: 0.23, blue: 0.32, alpha: 1.0)
    let filterButtonColor = UIColor.init(red: 0.42, green: 0.88 , blue: 0.92, alpha: 1.0)

    override func viewDidLoad() {
        
        let blur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(blurView)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let height = self.view.bounds.height - statusBarHeight
        let width = self.view.bounds.width
        
        buttons = [foodButton, employerButton, recoveryButton, gedButton, transportButton]
        
        for place in 0...5 {
            
            let barHeight = height/6
            let buttonSize = (3 * barHeight)/4
            let spacer = barHeight/8
            
            let buttonBar = BarButton()
            buttonBar.frame = CGRect(x: 0, y: statusBarHeight + CGFloat(place) * barHeight, width: width, height: barHeight)
            
            var button = UIButton()
            
            if place < icons.count {
                
                button = buttons[place]
                
                button.frame = CGRect(x: spacer, y: statusBarHeight + CGFloat(place) * barHeight + spacer, width: buttonSize, height: buttonSize)
                button.setImage(icons[place], for: .normal)
                button.imageEdgeInsets = UIEdgeInsetsMake(barHeight/6,barHeight/6,barHeight/6,barHeight/6)
                button.backgroundColor = buttonColor
                button.layer.cornerRadius = button.frame.height/2
                button.layer.masksToBounds = true
                
                let buttonLabel = UIButton()
                buttonLabel.frame = CGRect(x: barHeight, y: statusBarHeight + CGFloat(place) * barHeight, width: width - barHeight, height: barHeight)
                buttonLabel.setTitle(iconLabels[place], for: .normal)
                buttonLabel.setTitleColor(UIColor.white, for: .normal)
                buttonLabel.titleLabel?.font = UIFont.systemFont(ofSize: 38, weight: .thin)
                buttonLabel.contentHorizontalAlignment = .left
                
                buttonBar.iconButton = button
                buttonBar.labelButton = buttonLabel
                
                buttonBar.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)

                self.view.addSubview(button)
                self.view.addSubview(buttonLabel)
                
            } else {
                
                button.frame = CGRect(x: width/8, y: barHeight/4, width: (3 * width)/4, height: barHeight/2)
                
                button.backgroundColor = filterButtonColor
                button.setTitle("Filter", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.layer.cornerRadius = button.frame.height/8
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
                button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
                
                buttonBar.addSubview(button)
                
            }
            
            self.view.addSubview(buttonBar)
        }
        
    }
    
    @objc func buttonTapped(button: BarButton) {
        
        if button.iconButton?.backgroundColor == buttonColor {
            button.iconButton?.backgroundColor = UIColor.lightGray
        } else if button.iconButton?.backgroundColor == UIColor.lightGray {
            button.iconButton?.backgroundColor = buttonColor
        }
        
    }
    
    func compileFields() -> [String] {
        
        var fields : [String] = []
        
        for button in buttons {
            if button.backgroundColor == UIColor.lightGray {
                fields.append(realLabels[icons.index(of: button.currentImage!)!])
            }
        }

        return fields
    }
    
    @objc func dismissModal() {
        self.modalDelegate.dismissFilter(modalText: compileFields())
    }
    
}
