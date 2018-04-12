//
//  TutorialModal.swift
//  Grit
//
//  Created by Jake Alvord on 4/5/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

protocol TutorialModalDelegate{
    func dismissTutorialModal(decision: Bool)
}

class TutorialModal : UIViewController {
    
    var tutorialModalDelegate: TutorialModalDelegate! = nil
    
    override func viewDidLoad() {
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let questionView = UIView()
        questionView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        questionView.backgroundColor = UIColor.white
        
        let questionLabel = UILabel()
        questionLabel.text = "How would you rate your smartphone proficiency?"
        questionLabel.frame = CGRect(x: width/16, y: height/8, width: (14 * width)/16, height: height/4)
        questionLabel.numberOfLines = 10
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.thin)
        
        let badButton = UIButton()
        badButton.frame = CGRect(x: width/16, y: height/2, width: (14 * width)/16, height: height/8)
        badButton.backgroundColor = UIColor.orange
        badButton.setTitle("Ya, I could use a tutorial", for: .normal)
        badButton.layer.cornerRadius = badButton.frame.height/8
        badButton.addTarget(self, action: #selector(dismissQuestionYes), for: .touchUpInside)
        
        let goodButton = UIButton()
        goodButton.frame = CGRect(x: width/16, y: 3*height/4, width: (14 * width)/16, height: height/8)
        goodButton.backgroundColor = UIColor.blue
        goodButton.setTitle("I'm good, no tutorial for me", for: .normal)
        goodButton.layer.cornerRadius = goodButton.frame.height/8
        goodButton.addTarget(self, action: #selector(dismissQuestionNo), for: .touchUpInside)
        
        questionView.addSubview(questionLabel)
        questionView.addSubview(goodButton)
        questionView.addSubview(badButton)
        
        self.view.addSubview(questionView)
    }
    
    @objc func dismissQuestionNo() {
        self.tutorialModalDelegate.dismissTutorialModal(decision: false)
    }
    
    @objc func dismissQuestionYes() {
        self.tutorialModalDelegate.dismissTutorialModal(decision: true)
        
    }
}
