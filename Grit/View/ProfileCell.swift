//
//  ProfileCell.swift
//  Grit
//
//  Created by Jared Williams on 3/21/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    
    lazy var optionsButton: GritOptionsButton = {
       let button = GritOptionsButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(self.optionsButton)
        
        Utility.constrain(new: self.optionsButton, to: self, top: nil, bottom: nil, left: nil, right: nil, height: 75, width: 75, centerX: true)
        self.optionsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
