//
//  ContactUsViewController.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/4/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Customize View Controller
        self.view.backgroundColor = colorScheme.backgroundColor
        self.title = "Contact Us"
        
        // Mail button
        
        let mailBtn = UIButton()
        let mailImg = UIImage(named: "mail")?.withRenderingMode(.alwaysTemplate)
        mailBtn.setImage(mailImg, for: .normal)
        mailBtn.tintColor = colorScheme.buttonColor
        mailBtn.setTitleColor(mailBtn.tintColor, for: .normal)
        mailBtn.setTitle("Click to email us", for: .normal)
        mailBtn.titleLabel?.font = fonts.textFont
        mailBtn.titleEdgeInsets.left = 10
        mailBtn.addTarget(self, action: #selector(mailButtonPressed), for: .touchUpInside)
        self.view.addSubview(mailBtn)
        
        // Website button
        let webBtn = UIButton()
        let webImg = UIImage(named: "globe-hand")?.withRenderingMode(.alwaysTemplate)
        webBtn.setImage(webImg, for: .normal)
        webBtn.tintColor = colorScheme.buttonColor
        webBtn.setTitleColor(webBtn.tintColor, for: .normal)
        webBtn.setTitle("Click to visit our website", for: .normal)
        webBtn.titleLabel?.font = fonts.textFont
        webBtn.titleEdgeInsets.left = 10
        webBtn.addTarget(self, action: #selector(webButtonPressed), for: .touchUpInside)
        self.view.addSubview(webBtn)
        
        // Constraints
        mailBtn.translatesAutoresizingMaskIntoConstraints = false
        mailBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mailBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        mailBtn.widthAnchor.constraint(equalToConstant: mailBtn.intrinsicContentSize.width + mailBtn.titleEdgeInsets.left).isActive = true
        mailBtn.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        webBtn.translatesAutoresizingMaskIntoConstraints = false
        webBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        webBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        webBtn.widthAnchor.constraint(equalToConstant: webBtn.intrinsicContentSize.width + webBtn.titleEdgeInsets.left).isActive = true
        webBtn.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func mailButtonPressed() {
        print("Mail button pressed")
        let email = "testEmail@osu.edu"
        if let url = URL(string: "mailto:\(email)") {
            print("Opening mail app")
            UIApplication.shared.open(url)
        }
    }
    
    @objc func webButtonPressed() {
        print("Web button pressed")
        if let url = URL(string: "https://osu.edu") {
            print("Opening safari")
            UIApplication.shared.open(url)
        }
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
