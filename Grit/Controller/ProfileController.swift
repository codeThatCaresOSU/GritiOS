//
//  ViewController.swift
//  Grit
//
//  Created by Jared Williams on 2/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var newsCell = "NEWS"
    var messageCell = "MESSAGE"

    
   
    private lazy var newsFeed: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: newsCell)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "KIND", withReuseIdentifier: "HEADER")
        
        return view
    }()
    
    private lazy var profileImage: UIImageView = {
       let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = view.frame.width / 2
        view.contentMode = .scaleAspectFill
        
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.textAlignment = .center
        
        let user = FirebaseManager.sharedInstance.getCurrentUser()
        
        label.text = "\(user.firstName!) \(user.lastName!)"
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        FirebaseManager.sharedInstance.getProfileImageFromFirebaseStorage() { (profileImage: UIImage) in
            self.profileImage.image = profileImage
        }

    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        self.view.addSubview(self.newsFeed)
        self.view.addSubview(self.profileImage)
        self.view.addSubview(self.nameLabel)
        
        Utility.constrain(new: self.newsFeed, to: self.view, top: 100, bottom: 0, left: nil, right: nil, height: nil, width: self.view.frame.width, centerX: false)
        Utility.constrain(new: self.nameLabel, to: self.view, top: 8, bottom: nil, left: nil, right: nil, height: 50, width: 200, centerX: true)
        
        self.profileImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.profileImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        

        self.profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.profileImage.image = #imageLiteral(resourceName: "humans")
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = 40
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.handleEditButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.handleLogout))
        

    }
    
    @objc func handleEditButton() {
        let actionSheet = UIAlertController(title: "Edit Your Profile", message: "What do you want to change?", preferredStyle: .actionSheet)
        
        let photoOption = UIAlertAction(title: "Change Profile Picture", style: .default) { (action) in
            let photoPicker = UIImagePickerController()
            photoPicker.delegate = self
            
            
            let photoAlert = UIAlertController(title: "Where would you like to get your profile image from?", message: "Would you like to retrieve your profile image from the camera or from a saved image", preferredStyle: .alert)
            photoAlert.addAction(UIAlertAction(title: "Photo Library", style: .default) { (action) in
                photoPicker.sourceType = .photoLibrary
                self.present(photoPicker, animated: true, completion: nil)
            })
            
            photoAlert.addAction(UIAlertAction(title: "Camera", style: .default) { (action) in
                photoPicker.sourceType = .camera
                self.present(photoPicker, animated: true, completion: nil)
            })
            
            self.present(photoAlert, animated: true, completion: nil)
        }
        
        let bioOption = UIAlertAction(title: "Change Your Description", style: .default) { (action) in
            let bioAlert = UIAlertController(title: "Enter in your new occupation", message: "What would you like to list your occupation as?" , preferredStyle: .alert)
            bioAlert.addTextField() { (textField) in
                textField.heightAnchor.constraint(equalToConstant: 100).isActive = true
                textField.placeholder = "Your New Description"
                textField.textAlignment = .left
            }
            
            bioAlert.addAction(UIAlertAction(title: "Done", style: .default) { (action) in
                FirebaseManager.sharedInstance.updateUserDescription(newDescription: (bioAlert.textFields![0].text!))
            })
            self.present(bioAlert, animated: true, completion: nil)
        }
        
        let occupationOption = UIAlertAction(title: "Change Your Occupation", style: .default) { (action) in
            let occupationAlert = UIAlertController(title: "Enter in your new occupation", message: "What would you like to list your occupation as?" , preferredStyle: .alert)
            occupationAlert.addTextField() { (textField) in
                textField.placeholder = "Your New Occupation"
            }
            self.present(occupationAlert, animated: true, completion: nil)
            
            occupationAlert.addAction(UIAlertAction(title: "Done", style: .default) { (action) in
                FirebaseManager.sharedInstance.updateUserOccupation(newOccupation: (occupationAlert.textFields![0].text!))
            })
            
        }
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        
        actionSheet.addAction(photoOption)
        actionSheet.addAction(bioOption)
        actionSheet.addAction(occupationOption)
        actionSheet.addAction(cancelOption)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        FirebaseManager.sharedInstance.logout()
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
        cell?.backgroundColor = .white
        cell?.layer.borderWidth = 3.0
        cell?.layer.borderColor = Colors.niceGreen.cgColor
        
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
    
    // --------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        self.profileImage.image = image
        
        FirebaseManager.sharedInstance.uploadUserImageToFirebaseStorage(image: image, completion: nil)
    }
}
