//
//  TempCellView.swift
//  Grit
//
//  Created by Jared Williams on 9/30/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class TempCellView : UICollectionViewCell {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label = UILabel(frame: self.frame)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        self.addSubview(self.label)

        
        Utility.constrain(new: self.label ?? UILabel(), to: self, top: nil, bottom: nil, left: nil, right: nil, height: self.frame.height, width: self.frame.width, centerX: true)
        self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.label?.text = "Mentor Features Coming Soon!"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
