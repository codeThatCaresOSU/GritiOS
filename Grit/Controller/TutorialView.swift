//
//  TutorialView.swift
//  Grit
//
//  Created by Jake Alvord on 4/4/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class TutorialView: TutorialController {
    
    var backgroundColor: UIColor!
    var describe : String!
    var notLastBool : Bool!
    var superTutorial : TutorialController!
    
    override func viewDidLoad() {
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        let photoWidth = (5 * width)/8
        let photoHeight = (5 * height)/8
        
        if notLastBool {
            
            let examplePhoto = UIView()
            examplePhoto.frame = CGRect(x: (width - photoWidth)/2, y: height/16, width: photoWidth, height: photoHeight)
            examplePhoto.backgroundColor = backgroundColor
            
            let label = UILabel()
            label.frame = CGRect(x: width/16, y: (3 * height)/4, width: (14 * width)/16, height: (3 * height)/16)
            label.text = describe
            label.textAlignment = .center
            label.numberOfLines = 10
            //label.backgroundColor = UIColor.lightGray
            
            self.view.backgroundColor = UIColor.white
            
            self.view.addSubview(label)
            self.view.addSubview(examplePhoto)
            
        } else {
            
            let tutorialEndLabel = UILabel()
            tutorialEndLabel.text = "That's it!"
            tutorialEndLabel.frame = CGRect(x: width/16, y: height/8, width: (14 * width)/16, height: height/4)
            tutorialEndLabel.numberOfLines = 10
            tutorialEndLabel.textAlignment = .center
            tutorialEndLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.thin)
            
            let redoLabel = UILabel()
            redoLabel.frame = CGRect(x: width/16, y: height/3, width: (14 * width)/16, height: height/3)
            redoLabel.text = "Swipe right to go through again\n\nOR"
            redoLabel.numberOfLines = 5
            redoLabel.textAlignment = .center
            redoLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.thin)
            
            let doneButton = UIButton()
            doneButton.frame = CGRect(x: width/16, y: 3*height/4, width: (14 * width)/16, height: height/8)
            doneButton.backgroundColor = UIColor.blue
            doneButton.setTitle("Tap here to finish", for: .normal)
            doneButton.layer.cornerRadius = doneButton.frame.height/8
            doneButton.addTarget(superTutorial, action: #selector(triggerDismiss), for: .touchUpInside)
            
            self.view.backgroundColor = UIColor.white
            
            self.view.addSubview(tutorialEndLabel)
            self.view.addSubview(doneButton)
            self.view.addSubview(redoLabel)
            
        }
        
    }
    
}
