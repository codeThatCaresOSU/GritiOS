//
//  HeaderView.swift
//  Grit
//
//  Created by Jared Williams on 2/28/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: UICollectionReusableView {
    
    var textLabel = UILabel()
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
        self.addSubview(self.textLabel)
        
        Utility.constrain(new: self.textLabel, to: self, top: nil, bottom: nil, left: nil, right: nil, height: self.frame.height, width: self.frame.width, centerX: true)
        
    }
    
    func setText(text: String) {
        self.textLabel.text = text
    }
    
}
