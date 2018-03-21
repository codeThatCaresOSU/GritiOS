//
//  OptionsView.swift
//  Grit
//
//  Created by Jared Williams on 3/20/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class OptionsView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
   
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupView()
        
    }
    
    convenience init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        self.init(frame: frame, collectionViewLayout: layout)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.register(ProfileCell.self, forCellWithReuseIdentifier: "reuse")
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.delegate = self
        self.dataSource = self
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuse", for: indexPath) as! ProfileCell
        
        
        if indexPath.row == 0 {
            cell.optionsButton.setBackgroundImage(#imageLiteral(resourceName: "user"), for: .normal)
        } else if indexPath.row == 1 {
            cell.optionsButton.setBackgroundImage(#imageLiteral(resourceName: "bus"), for: .normal)
        } else {
            cell.optionsButton.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 3, height: self.frame.height)
    }

}
