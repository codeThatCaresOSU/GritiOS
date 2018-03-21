//
//  AllDoneSignUpController.swift
//  Grit
//
//  Created by Jared Williams on 2/22/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation

class AllDoneSignUpController: GritSignUpController {
    override func viewDidLoad() {
        
         self.setupView()
         self.setupDoneView()
    }
    
    func setupDoneView() {
        
        self.rightButton.setTitle("All Done", for: .normal)
        self.rightButton.removeConstraints(self.rightButton.constraints)
        self.leftButton.isHidden = true
        
        self.descriptionLabel.text = "YOU'RE SET\nENJOY GRIT!"
        
        Utility.constrain(new: self.rightButton, to: self.view, top: nil, bottom: -8, left: nil, right: nil, height: 50, width: self.view.frame.width - 20, centerX: true)
    }
    
    
    override func nextScreen() {
        self.present(HomeController(), animated: true, completion: nil)
    }
}
