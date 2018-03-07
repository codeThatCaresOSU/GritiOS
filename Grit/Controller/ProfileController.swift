//
//  ViewController.swift
//  Grit
//
//  Created by Jared Williams on 2/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var newsCell = "NEWS"
    var messageCell = "MESSAGE"
   
    private lazy var newsFeed: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: newsCell)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "KIND", withReuseIdentifier: "HEADER")
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()

    }
    
        
    
    
    
    func setupView() {
        self.tabBarController?.tabBarItem.title = "Profile"
        self.tabBarController?.navigationController?.navigationBar.topItem?.title = FirebaseManager.sharedInstance.getCurrentUser().firstName
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.newsFeed)
        
        Utility.constrain(new: self.newsFeed, to: self.view, top: 100, bottom: 0, left: nil, right: nil, height: nil, width: self.view.frame.width, centerX: false)
    }
    
    // ------------------
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell?
        
        if indexPath.section == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCell, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCell, for: indexPath)
        }
        
        cell?.layer.cornerRadius = 20
        cell?.backgroundColor = .purple
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "KIND", withReuseIdentifier: "HEADER", for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width - 20, height: 50)
    }
}
