//
//  ViewController.swift
//  Grit
//
//  Created by Jared Williams on 2/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var newsCell = "NEWS"
    var messageCell = "MESSAGE"
    var fillerCell = "FILLER"
    var mentorFillerCell = "MENTORFILLER"
    var optionsView = OptionsView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))

    let user = FirebaseManager.sharedInstance.getCurrentUser()
    
    
    private lazy var newsFeed: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.delegate = self
        view.dataSource = self
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.black.cgColor
        
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: newsCell)
        view.register(UICollectionReusableView.self, forSupplementaryViewOfKind: "KIND", withReuseIdentifier: "HEADER")
        
        // register the chat cells
        view.register(UserCell.self, forCellWithReuseIdentifier: messageCell)
        view.register(FindMentorCell.self, forCellWithReuseIdentifier: fillerCell)
        view.register(MentorFillerCell.self, forCellWithReuseIdentifier: mentorFillerCell)
        
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
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        
        return label
    }()
    
    private lazy var jobLabel: UILabel = {
        let label = UILabel()
       
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.textAlignment = .center
        label.text = "Occupation: \(user.occupation ?? "Not Set")"
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        observeUserMessages()
        
        FirebaseManager.sharedInstance.getProfileImageFromFirebaseStorage() { (profileImage: UIImage) in
            self.profileImage.image = profileImage
        }
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        // set correct back button for nav controller TO-DO this does not work
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.tabBarController?.navigationController?.navigationItem.backBarButtonItem = backButton
        self.navigationController?.navigationItem.rightBarButtonItem?.tintColor = Colors.niceGreen
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.newsFeed)
        self.view.addSubview(self.profileImage)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.jobLabel)
        
        Utility.constrain(new: self.newsFeed, to: self.view, top: 100, bottom: 0, left: nil, right: nil, height: nil, width: self.view.frame.width, centerX: true)
        Utility.constrain(new: self.nameLabel, to: self.view, top: 8, bottom: nil, left: nil, right: nil, height: 50, width: 200, centerX: false)
        self.nameLabel.leftAnchor.constraint(equalTo: self.profileImage.rightAnchor, constant: 8).isActive = true
        
        Utility.constrain(new: self.jobLabel, to: self.nameLabel, top: nil, bottom: 33, left: nil, right: nil, height: 55, width: 200, centerX: true)
        
        self.profileImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        self.profileImage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        self.profileImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        self.profileImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.profileImage.image = #imageLiteral(resourceName: "humans")
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.cornerRadius = 40
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.handleEditButton))
        self.navigationItem.leftBarButtonItem?.tintColor = Colors.niceGreen
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(self.handleLogout))
        self.navigationItem.rightBarButtonItem?.tintColor = Colors.niceGreen
        

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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (section == 0) {
            if (messagesDictionary.count > 0) {
                return messagesDictionary.count
            } else {
                // filler cell acts as a find a mentor button for mentees
                return 1
            }
        } else {
            return 3
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell?
        

        // TO-DO clean this up
        
        if indexPath.section == 0 {
            // get messaging cell type
            return getMessageCellType(collectionView, indexPath: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: newsCell, for: indexPath)
        }
        
        cell?.layer.cornerRadius = 20
        cell?.backgroundColor = .purple

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            // TO-DO Implement this... this can activate the find mentor thing too, check the first cell and messages length...
            let isMentor = FirebaseManager.sharedInstance.getCurrentUser().mentorStatus
            if (messagesDictionary.count > 0) {
                // go into a chatlog with the user, as in game of chats
                handleChat(indexPath: indexPath)
                // only mentees
            } else if (indexPath.row == 0) {
                // we only care about mentees here, this activates the find mentor function? Include boolean check for mentor
                print("Off to find a mentor!!")
                sendMessageToFriend(user: friend)
            }
        }
        // sendMessageToFriend(user: friend)
    }
    
    func getMessageCellType(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let isMentor = FirebaseManager.sharedInstance.getCurrentUser().mentorStatus
        // TO-DO can I clean this up any more?
        if (messagesDictionary.count > 0) {
            let msgCell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCell, for: indexPath) as! UserCell
            let message = messages[indexPath.row]
            msgCell.message = message
            msgCell.layer.cornerRadius = 20
            msgCell.backgroundColor = UIColor.white
            return msgCell
        } else {
            // TO-DO put in the filler cell if no messages exist, mentee and mentor are different!
            if (isMentor?.rawValue == 1) {
                let mentorFillCell = collectionView.dequeueReusableCell(withReuseIdentifier: mentorFillerCell, for: indexPath)
                    as! MentorFillerCell
                mentorFillCell.layer.cornerRadius = 20
                mentorFillCell.backgroundColor = UIColor.white
                return mentorFillCell
            } else {
                let msgFillerCell = collectionView.dequeueReusableCell(withReuseIdentifier: fillerCell, for: indexPath)
                    as! FindMentorCell
                msgFillerCell.layer.cornerRadius = 20
                msgFillerCell.backgroundColor = UIColor.white
                return msgFillerCell
            }
        }
    }
    
    // Chat Interface and Implementation, can we refactor this?
    
    var messages = [Message]()
    var messagesDictionary = [String:Message]()
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        // reference to the child node that holds referecnces to users messages
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            // actually observe the messages
            let partnerId = snapshot.key
            
            // go along with the message fix, we must go a level deeper and get messages to
            // and from a specific user, reference to those messages
            
            Database.database().reference().child("user-messages")
                .child(uid).child(partnerId).observe(.childAdded, with: { [weak self] (snapshot) in
                    
                let messageId = snapshot.key
                // fetch all messages, should we use weak self here?
                self!.fetchMessageWithMessageId(messageId: messageId)
                    
                }, withCancel: nil)
        }, withCancel: nil)
        
        // deals with messages being removed outside of app (eg firebase console)
        ref.observe(.childRemoved, with: { (snapshot) in
            // snapshot .key is really the childPartnerId and node inside logged in user messages tree
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        }, withCancel: nil)
    }
    
    // populates a dictionary with most recent messages from each user
    private func fetchMessageWithMessageId(messageId: String) {
        
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        // observe the messages inside the user messages tree for the specific user
        messagesReference.observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                
                // populate the message with data
                let message = Message(values: dictionary)
                
                // append message with the receipient as well, contains the latest message since keys are resused
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                // To-Do should we ever use self inside a closure block? Weak self maybe?
                self.attemptReloadOfTable()
            }
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    private func attemptReloadOfTable() {
        // cancels faster then it can fire off, saves the only fire off for the end
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                          selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    // a workaround, should probably fix and make more efficient
    @objc func handleReloadTable() {
        // done inside handle reload table so that the array and sorting work is only done once, #efficiency
        // messages now stores a single message for each person
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) -> Bool in
            // To-Do unwrap these safely or use a guard statement
            if let timestamp1 = message1.timestamp, let timestamp2 = message2.timestamp {
                return timestamp1.intValue > timestamp2.intValue
            }
            print("Error unwrapping timestamps :(")
            return false
        })
        
        // must use Dispatch threading or else it will crash on the background thread
        DispatchQueue.main.async {
            self.newsFeed.reloadData()
        }
    }
    
    // temporary send button to help debug and get things rolling...
    let friend: ChatUser = {
        let user = ChatUser()
        user.name = "Ian Willis"
        user.profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/grit-f9d52.appspot.com/o/User_Profile_Images%2F1DzFNjd67nX9jHrb9eFLtxM6c4g1?alt=media&token=2cf0b382-abe4-43ce-90f3-6bdfef50ff34"
        user.id = "1DzFNjd67nX9jHrb9eFLtxM6c4g1"
        return user
    }()
    
    @objc func sendMessageToFriend(user: ChatUser) {
        showChatControllerForUser(user: friend)
    }
    
    // open a chatlog with the specified user
    func handleChat(indexPath: IndexPath) {
        let message = messages[indexPath.row]
        // figure out which user is which
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("Users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // get the chat partner node in the tree
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            // the recipient of the messages
            let user = ChatUser(values: dictionary)
            user.id = chatPartnerId
            // open a chatlog
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
    }
    
    @objc func showChatControllerForUser(user: ChatUser) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        // set recipient
        chatLogController.user = user
        // self.tabBarController?.navigationController?.pushViewController(chatLogController, animated: true)
        self.navigationController?.pushViewController(chatLogController, animated: true)
        if let currentOffset = UserDefaults.standard.object(forKey: "messageOffset") as! CGFloat? {
            chatLogController.currentMessageOffset = currentOffset
        }
    }
    
    // TO-DO make delectiona thing, if mentor deletes its over, if mentee deletes its not?
    // --------
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        self.profileImage.image = image
        
        FirebaseManager.sharedInstance.uploadUserImageToFirebaseStorage(image: image, completion: nil)
    }
}

