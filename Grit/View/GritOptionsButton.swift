//
//  GritOptionsButton.swift
//  Grit
//
//  Created by Jared Williams on 2/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class GritOptionsButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.tintColor = .white
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addShadow()
    }

}
