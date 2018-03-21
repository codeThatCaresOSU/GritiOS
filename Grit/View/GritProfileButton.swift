//
//  GritProfileButton.swift
//  Grit
//
//  Created by Jared Williams on 3/20/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class GritProfileButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addShadow()
        
        self.backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
