//
//  ViewController.swift
//  Grit
//
//  Created by Jared Williams on 2/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
    
    
    
    private lazy var mainScrollView: UIScrollView = {
        let view = UIScrollView(frame: self.view.frame)
        
        view.backgroundColor = .white
        
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    func setupView() {
        self.tabBarController?.tabBarItem.title = "Profile"
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        self.view.backgroundColor = .white
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignKeyboard)))
        
        login()
        
    }
    
    @objc func resignKeyboard() {
        self.view.subviews.forEach() {
            if $0 is UIScrollView {
                $0.subviews.forEach() {
                    if $0 is UITextField {
                        $0.resignFirstResponder()
                    }
                }
            }
        }
    }
    
    func login() {
        Utility.createTextFieldsAndConstrainToView(view: self.mainScrollView, placeholders: ["First Name", "Last Name", "Zip Code", "Email", "Password"])
        self.view.addSubview(self.mainScrollView)
    }
    
    func profile() {
        
    }
}

