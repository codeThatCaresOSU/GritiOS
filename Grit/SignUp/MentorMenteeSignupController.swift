//
//  MentorMenteeSignupController.swift
//  Grit
//
//  Created by Jared Williams on 2/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class MentorMenteeSignupController: GritSignUpController {
    
    
    lazy var maleButton: GritOptionsButton = {
       let button = GritOptionsButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setTitle("Male", for: .normal)
        button.addTarget(self, action: #selector(self.sexButtonPressed), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        button.backgroundColor = Colors.niceBlue
        return button
    }()
    
    lazy var femaleButton: GritOptionsButton = {
        let button = GritOptionsButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setTitle("Female", for: .normal)
        button.backgroundColor = Colors.nicePink
        return button
    }()
    
    
    
    override func viewDidLoad() {
        self.setupView()
        self.setupMentorView()
    }
    
    func setupMentorView() {
        
        self.view.backgroundColor = .white
        
        self.descriptionLabel.numberOfLines = 3
        self.descriptionLabel.text = "MALE\nOR\nFEMALE"
        
        self.leftButton.setTitle("Back", for: .normal)
        self.rightButton.setTitle("Next", for: .normal)
        
        Utility.constrain(new: self.maleButton, to: self.descriptionLabel, top: 300, bottom: nil, left: 8, right: nil, height: 50, width: self.view.frame.width - 20, centerX: true)
        Utility.constrain(new: self.femaleButton, to: self.descriptionLabel, top: 375, bottom: nil, left: nil, right: -8, height: 50, width: self.view.frame.width - 20, centerX: true)
    }
    
    @objc func sexButtonPressed() {
        self.maleButton.backgroundColor = .red
        print("sex")
    }
}
