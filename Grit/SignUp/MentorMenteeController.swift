//
//  MentorMenteeController.swift
//  Grit
//
//  Created by Jared Williams on 2/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class MentorMenteeController: GritSignUpController {
    
    lazy var mentorButton: GritOptionsButton = {
        let button = GritOptionsButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setTitle("Mentor", for: .normal)
        button.addTarget(self, action: #selector(self.mentorButtonPressed(sender:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.backgroundColor = Colors.niceBlue
        return button
    }()
    
    lazy var menteeButton: GritOptionsButton = {
        let button = GritOptionsButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setTitle("Mentee", for: .normal)
        button.addTarget(self, action: #selector(self.mentorButtonPressed(sender:)), for: .touchUpInside)
        button.backgroundColor = Colors.nicePink
        return button
    }()
    
    override func viewDidLoad() {
        self.setupView()
        self.setupMentorView()
    }
    
    func setupMentorView() {
        
        self.leftButton.setTitle("Back", for: .normal)
        self.rightButton.setTitle("Next", for: .normal)
        
        self.descriptionLabel.numberOfLines = 3
        self.descriptionLabel.text = "MENTOR\nOR\nMENTEE"
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.menteeButton)
        self.view.addSubview(self.mentorButton)
        
        Utility.constrain(new: self.mentorButton, to: self.view, top: 300, bottom: nil, left: nil, right: nil, height: 50, width: self.view.frame.width - 20, centerX: true)
        Utility.constrain(new: self.menteeButton, to: self.view, top: 375, bottom: nil, left: nil, right: nil, height: 50, width: self.view.frame.width - 20, centerX: true)
    }
    
    @objc func mentorButtonPressed(sender: UIButton) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        imageView.image = #imageLiteral(resourceName: "check")
        
        mentorButton.subviews.forEach() {
            
            if $0 is UIImageView {
                $0.removeFromSuperview()
            }
        }
        
        menteeButton.subviews.forEach() {
            if $0 is UIImageView {
                $0.removeFromSuperview()
            }
        }
        
        sender.addSubview(imageView)
        print("sex")
    }
    
    override func nextScreen() {
        self.navigationController?.pushViewController(DateSignUpController(), animated: true)
    }
}
