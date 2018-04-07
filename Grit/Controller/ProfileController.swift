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
        
        // register the chat cell, can we have more than one type of cell??
        view.register(UserCell.self, forCellWithReuseIdentifier: messageCell)
        
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
        // can this vary in section 1? I want messges dictionary, we need to big time
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell: UICollectionViewCell?
        
        if indexPath.section == 0 {
            // first section is all messaiging stuff
            // a single cell with have the recipient and the text, work in progress for now
            // only add if the index exists...
            if (indexPath.row <= messagesDictionary.count) {
                let msgCell = collectionView.dequeueReusableCell(withReuseIdentifier: messageCell, for: indexPath) as! UserCell
                let message = messages[indexPath.row]
                msgCell.message = message
                msgCell.layer.cornerRadius = 20
                msgCell.backgroundColor = UIColor.blue
                return msgCell
            }
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
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // TO-DO Implement this... this can activate the find mentor thing too, check the first cell and messages length...
        if (messagesDictionary.count > 0) {
            // go into a chatlog with a user
        } else if true {
            // if a mentee then display the find mentor button
        } else {
            // mentor with no messages... what to display here
        }
    }
    
    // Chat Interface and Implementation
    
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
                let message = Message()
                // do it the long way for now, set value for key would not work even after double checking keys
                message.fromId = dictionary["fromId"] as? String
                message.toId = dictionary["toId"] as? String
                message.text = dictionary["text"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                // self.messages.append(message)
                
                // append message with the receipient as well, contains the latest message since keys are resused
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                // To-Do should we ever use self inside a closure block?
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
            // self.tableView.reloadData()
            // how do you reload data in the collection view?
        }
    }
    
//    // when any message collection cell is clicked on, open a chatlog with that person
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let message = messages[indexPath.row]
//        // figure out which user is which
//        guard let chatPartnerId = message.chatPartnerId() else {
//            return
//        }
//
//        let ref = Database.database().reference().child("Users").child(chatPartnerId)
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            // get the chat partner node in the tree
//            guard let dictionary = snapshot.value as? [String: AnyObject] else {
//                return
//            }
//
//            // the recipient of the messages
//            let user = ChatUser()
//            user.id = chatPartnerId
//            user.setValuesForKeys(dictionary)
//            self.showChatControllerForUser(user: user)
//
//        }, withCancel: nil)
//    }
    
    @objc func showChatControllerForUser(user: ChatUser) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        // set recipient
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
