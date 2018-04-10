//
//  ViewController.swift
//  Grit
//
//  Created by Jared Williams on 2/7/18.
//  Copyright © 2018 Jared Williams. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var newsCell = "NEWS"
    var messageCell = "MESSAGE"
    var fillerCell = "FILLER"
    var mentorFillerCell = "MENTORFILLER"
    var optionsView = OptionsView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
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
        
        // register the chat cells
        view.register(UserCell.self, forCellWithReuseIdentifier: messageCell)
        view.register(FindMentorCell.self, forCellWithReuseIdentifier: fillerCell)
        view.register(MentorFillerCell.self, forCellWithReuseIdentifier: mentorFillerCell)
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        observeUserMessages()
    }
    
    func setupView() {
        self.tabBarController?.tabBarItem.title = "Profile"
        self.tabBarController?.navigationController?.navigationBar.topItem?.title = FirebaseManager.sharedInstance.getCurrentUser().firstName
        self.view.backgroundColor = .white
        
        // set correct back button for nav controller TO-DO this does not work
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.tabBarController?.navigationController?.navigationItem.backBarButtonItem = backButton
        
        self.view.addSubview(self.newsFeed)
        self.view.addSubview(self.optionsView)
        
        Utility.constrain(new: self.newsFeed, to: self.view, top: 100, bottom: 0, left: nil, right: nil, height: nil, width: self.view.frame.width, centerX: false)
        
        Utility.constrain(new: self.optionsView, to: self.view, top: 0, bottom: nil, left: 0, right: nil, height: nil, width: nil, centerX: false)
        
        self.optionsView.bottomAnchor.constraint(equalTo: self.newsFeed.topAnchor).isActive = true
    }
    
    // ------------------
    
    
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
        self.tabBarController?.navigationController?.pushViewController(chatLogController, animated: true)
        if let currentOffset = UserDefaults.standard.object(forKey: "messageOffset") as! CGFloat? {
            chatLogController.currentMessageOffset = currentOffset
        }
    }
    
    // TO-DO make delectiona thing, if mentor deletes its over, if mentee deletes its not?
}
