//
//  OptionsView.swift
//  Grit
//
//  Created by Jared Williams on 3/20/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class OptionsView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var profileButton = GritProfileButton()
    lazy var mentorButton = GritProfileButton()
    lazy var settingsButton = GritProfileButton()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.setupView()
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "reuse")
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = .yellow
        self.delegate = self
        self.dataSource = self
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuse", for: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width / 3, height: self.frame.height)
    }

}
