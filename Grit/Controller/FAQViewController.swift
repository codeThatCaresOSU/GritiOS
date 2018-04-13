//
//  FAQViewController.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/4/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize View Controller
        self.view.backgroundColor = colorScheme.backgroundColor
        self.title = "Frequently Asked Questions"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
