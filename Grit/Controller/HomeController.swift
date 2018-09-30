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
        
        let mapController = Utility.createNavigationController(title: "Resources", controller: ResourcesViewController(), buttons: nil, color: .black, tabTitle: "Resources", textColor: Colors.niceGreen)
        let profileController = Utility.createNavigationController(title: "Profile", controller: ProfileController(), buttons: nil, color: .black, tabTitle: "Profile", textColor: Colors.niceGreen)
        let settingsController = Utility.createNavigationController(title: "Settings", controller: SettingsViewController(), buttons: [], color: .black, tabTitle: "Settings", textColor: Colors.niceGreen)
        
        profileController.tabBarItem.image = UIImage(named: "user")
        mapController.tabBarItem.image = UIImage(named: "place")
        settingsController.tabBarItem.image = UIImage(named: "settings")


       self.viewControllers = [profileController, mapController, settingsController]
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.tintColor = Colors.niceGreen
    }
}
