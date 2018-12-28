//
//  UserCell.swift
//  GameOfChats
//
//  Created by Frank  on 3/9/18.
//  Copyright © 2018 Frank . All rights reserved.
//

import UIKit
import Firebase

class UserCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            setUpNameAndProfileImage()
            
            self.detailTextLabel?.text = message?.text
            
            // convert timestamp to date
            if let seconds = message?.timestamp?.doubleValue {
                let timeStampDate = NSDate(timeIntervalSince1970: seconds)
                // make the date work, pretty sure we want to use Date class and not NSDate, works actually
                let dateFormatter = DateFormatter()
                //dateFormatter.dateFormat = "hh:mm:ss a"
                // dateFormatter.dateFormat = "hh:mm a"
                // always use time and date style over the format string
                dateFormatter.timeStyle = .short
                timeLabel.text = dateFormatter.string(from: timeStampDate as Date)
            }
        }
    }
    
    private func setUpNameAndProfileImage() {
        if let id = message?.chatPartnerId() {
            // get user that corresponds to the uid
            let ref = Database.database().reference().child("Users").child(id)
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.nameLabel?.text = dictionary["Name"] as? String
                    // get user image with profile image url
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                    }
                }
            }, withCancel: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    // make our own image view
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // half the width and height for a circle
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    // the name label
    let nameLabel: UILabel? = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    // the text label
    let detailTextLabel: UILabel? = {
        let label = UILabel()
        // label.text = "HR:MM:SS"
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false;
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        
        // add the image view to the cell
        addSubview(profileImageView)
        addSubview(timeLabel)
        addSubview(detailTextLabel!)
        addSubview(nameLabel!)
        
        // layout constraints
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        // nameLabel constraints x,y,h,w align both left, like a normal table view cell essentially
        nameLabel?.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel?.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 4).isActive = true
        // not sure about width and height...
        nameLabel?.widthAnchor.constraint(equalToConstant: 256).isActive = true
        nameLabel?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // detailLabel constraints not showing up right now...
        detailTextLabel?.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        detailTextLabel?.topAnchor.constraint(equalTo: (nameLabel?.bottomAnchor)!, constant: 8).isActive = true
        detailTextLabel?.widthAnchor.constraint(equalToConstant: 164).isActive = true
        detailTextLabel?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        // x,y,h,w for time label
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (nameLabel?.heightAnchor)!, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
