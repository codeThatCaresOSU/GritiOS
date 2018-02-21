//
//  GritSignUpController.swift
//  Grit
//
//  Created by Jared Williams on 2/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class GritSignUpController: UIViewController {
    
    lazy var leftButton: UIButton = {
       let button = UIButton()
        
        button.layer.cornerRadius = 20
        button.backgroundColor = Colors.niceGreen
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(self.lastScreen), for: .touchUpInside)
       return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 20
        button.backgroundColor = Colors.niceGreen
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(self.nextScreen), for: .touchUpInside)
        
        return button
    }()
    
    lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont(name: "AvenirNext-HeavyItalic", size: 50)
        label.text = "You Look\n New Here"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
    }
    
    func setupView() {
        Utility.constrain(new: self.leftButton, to: self.view, top: nil, bottom: -8, left: 15, right: nil, height: 50, width: 125, centerX: false)
        Utility.constrain(new: self.rightButton, to: self.view, top: nil, bottom: -8, left: nil, right: -15, height: 50, width: 125, centerX: false)
        Utility.constrain(new: self.descriptionLabel, to: self.view, top: 8, bottom: nil, left: nil, right: nil, height: 300, width: self.view.frame.width - 20, centerX: true)
        self.view.backgroundColor = .white
        self.leftButton.addShadow()
        self.rightButton.addShadow()
    }
    
    @objc func nextScreen() {
        self.navigationController?.pushViewController(NameController(), animated: true)
    }
    
    @objc func lastScreen() {
        self.navigationController?.popViewController(animated: true)
    }
}
