//
//  ChatLogControllerswift
//  GameOfChats
//
//  Created by Frank  on 3/8/18.
//  Copyright © 2018 Frank . All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate,
UICollectionViewDelegateFlowLayout {
    
    // the user we are sending messages to, really confusing, maybe call chat partner?
    var user: ChatUser? {
        didSet {
            // To-Do update based on what we need for GRIT
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id else {
            return
        }
        // observe user messages object, a reference to a users messages to the user they are in chat with only
        // so only get messages for the current partner and that is it
        let userMessaagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessaagesRef.observe(.childAdded, with: { (snapshot) in
            // get all referenced messages, each key points to a single message
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                // populate message
                let message = Message(values: dictionary)
                
                // want to filter messages based on the user we are interacting with so that
                // we don't grab messages until we need them.
                
                // no need to filter by chat partner id anymore because of the new db structure
                self.messages.append(message)
                // reload data just like a table view, we are in a background thred remember
                // ALL UI STUFF DONE ON THE MAIN QUEUE
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    let cellid = "cellid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // offset from the top nav bar to give spacing, just top padding and bottom padding so input does not block
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        // these usually change in unison
        // collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellid)
        collectionView?.alwaysBounceVertical = true
        
        // this allows us to do the cool animted accessory view
        collectionView?.keyboardDismissMode = .interactive
    }
    
    // remeber that we cannot refer to self inside a closure due to memory stuffs, bottom input area
    lazy var inputContainerView: ChatInputContainerView = {
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        // allows us to use this current instance of chat log controller inside of the extension
        chatInputContainerView.chatLogController = self
        return chatInputContainerView
    }()
    
    // gives us the ability to swipe down and exit the keyboard in style
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    // neccessary for us to override input Accessory View
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillShow),
                name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillHide),
                name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // we have to call this or a memory leak will occur
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        // move input area back down to the bottom of the container view
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!) {
            // call this to animate constraints after the constraint has been changed
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillShow(notifcation: NSNotification) {
        // gets the frame of the keyboard
        let keyboardFrame = (notifcation.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notifcation.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        // move input area up based on keyboard height
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!) {
            // call this to animate constraints after the constraint has been changed
            self.view.layoutIfNeeded()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // number of entries in array determines the number of cells in the table
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! ChatMessageCell
        
        // custom cell text view
        let message = self.messages[indexPath.item]
        cell.textView.text = message.text
        
        setUpCell(cell: cell, message: message)
        
        // modify the bubble view width somehow, change width of bubble view to match the text
        if let text = message.text {
            // constant value gives needed padding
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
        }
        
        return cell
    }
    
    private func setUpCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        // determine wether message is incoming or outgoing
        if message.fromId == Auth.auth().currentUser?.uid {
            // outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.white
            
            // image should not appear if its a user message
            cell.profileImageView.isHidden = true
            
            // always flip so deqeued cells are not messed up, message is pinned to right
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        } else {
            // incoming grey
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            // message is pinned to the profile image on the left
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // requires the view to be redrawn and will allow the view to fit to the sides when rotated
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        // get estimated height of the message to get proper height of the cell
        if let text = messages[indexPath.item].text {
            // 20 is a constant that fills out the text field correctly
            height = estimateFrameForText(text: text).height + 20
        }
        // used because accessory view gives us a stange bug if we use self.view.width
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    // return the estimated size of a block of text
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        // no clue what this does
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options,
                                                   attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)],
                                                   context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    // does this just set up the view?? Unsure if we need this or not...
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        // set to white so we can see the input still
        containerView.backgroundColor = UIColor.white
        self.view.addSubview(containerView)
        
        // constraint time
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func handleSend() {
        
        // send a message
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        // want to send to a specific user, send and receive from uid, based on user global var
        let toId = user!.id!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSDate.timeIntervalSinceReferenceDate as NSNumber
        let values: [String: Any] = ["text": self.inputContainerView.inputTextField.text!, "toId": toId,
                                     "fromId": fromId, "timestamp": timestamp]
        // childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            // clear message dialouge
            self.inputContainerView.inputTextField.text = nil
            
            // store user messgaes under their id essentially, organizes them
            // this is called fanning out, the messages node still gets the message and data
            // but the user message node keeps a reference to that message under a specific user
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            // the edit we made was going to another child level to add more data to our user message node, not
            // much clearer who the message is to and from, saves us that money
            
            // same as above except for the recipient, so the chat actually works
            let recipientUserMessageRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessageRef.updateChildValues([messageId: 1])
        }
    }
}

