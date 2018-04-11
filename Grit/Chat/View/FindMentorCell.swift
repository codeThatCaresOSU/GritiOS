//
//  MessageFillerCell.swift
//  Grit
//
//  Created by Frank  on 4/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class FindMentorCell: UICollectionViewCell {
    // this cell acts as a filler to help with chat implementation, may not always be used
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.text = "Click here to find a mentor now!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        
        // constrain the subviews
        
        // text label constraints
        textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
