//
//  DefaultTableViewCell.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/22/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.selectionStyle = .none
        self.backgroundColor = colorScheme.backgroundColor
        self.textLabel?.font = fonts.textFont
        self.textLabel?.textColor = colorScheme.textColor
        self.layer.borderWidth = cellFormats.cellBorderSize
        self.layer.borderColor = colorScheme.headerColor.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
