//
//  HomeController.swift
//  Grit
//
//  Created by Jared Williams on 2/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class HomeController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    func setupView() {
       self.viewControllers = [Utility.createNavigationController(title: "Profile", controller: ProfileController(), buttons: nil, color: .white, tabTitle: "Profile", textColor: .black)]
    }
}
