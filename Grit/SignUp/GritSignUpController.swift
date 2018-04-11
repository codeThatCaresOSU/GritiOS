//
//  GritSignUpController.swift
//  Grit
//
//  Created by Jared Williams on 2/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit


var signUpUser = User()

class GritSignUpController: UIViewController {
    
    var hasMoved = false
    
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
        self.navigationItem.title = "Grit"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resign)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.view.addSubview(self.leftButton)
        self.view.addSubview(self.rightButton)
        self.view.addSubview(self.descriptionLabel)
        
        Utility.constrain(new: self.leftButton, to: self.view, top: nil, bottom: -8, left: 15, right: nil, height: 50, width: 125, centerX: false)
        Utility.constrain(new: self.rightButton, to: self.view, top: nil, bottom: -8, left: nil, right: -15, height: 50, width: 125, centerX: false)
        Utility.constrain(new: self.descriptionLabel, to: self.view, top: 8, bottom: nil, left: nil, right: nil, height: 300, width: self.view.frame.width - 20, centerX: true)
        self.view.backgroundColor = .white
        self.leftButton.addShadow()
        self.rightButton.addShadow()
        self.navigationController?.navigationItem.setLeftBarButton(nil, animated: true)
    }
    
    @objc func nextScreen() {
        self.navigationController?.pushViewController(EmailSignUpController(), animated: true)
    }
    
    @objc func lastScreen() {
        self.navigationController?.pushViewController(LoginController(), animated: true)
    }
    
    @objc func keyboardShow(notification: NSNotification) {
        if !hasMoved {
            let keyboardRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let height = keyboardRect.height
            
            self.descriptionLabel.frame.origin.y -= height
    
            self.hasMoved = true
        }
    }
    
    @objc func keyboardHide(notification: NSNotification) {
        //self.view.subviews.forEach() {
            
            //$0.frame.origin.y += (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
            self.hasMoved = false
        //}
    }
    
    @objc func resign() {
        self.view.subviews.forEach() {
            if $0 is UITextField {
                $0.resignFirstResponder()
            }
        }
    }
}
