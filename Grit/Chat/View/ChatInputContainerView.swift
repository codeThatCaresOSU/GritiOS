//
//  ChatInputContainerView.swift
//  GameOfChats
//
//  Created by Frank  on 3/21/18.
//  Copyright © 2018 Frank . All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate {
    
    var chatLogController: ChatLogController? {
        didSet {
            // target is added when we set up the inputViewContainer in chat log Controller
            sendButton.addTarget(chatLogController, action: #selector(chatLogController?.handleSend), for: .touchUpInside)
        }
    }
    
    let sendButton = UIButton(type: .system)
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    // required in almost any class idk why
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        // not using this right now... might implement later, do the same thing as the send button to refactor
        //        let uploadImageView = UIImageView()
        //        // gotta get a real image here
        //        uploadImageView.image = UIImage(named: "winterIsComing")
        //        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        //        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        //        uploadImageView.isUserInteractionEnabled = true
        
        //        addSubview(uploadImageView)
        //        // x, y, w, h constraints
        //
        //        uploadImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        //        uploadImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        //        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        //        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // .system gives us highlight and down state which is sweet
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sendButton)
        // x,y,h,w
        sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor, constant: 0).isActive = true
        
        addSubview(inputTextField)
        // x,y,h,w
        inputTextField.leftAnchor.constraint(equalTo: leftAnchor , constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: 0).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // create seperator line
        let separatorLineView = UIView()
        // change this color later and adjust where container view is
        separatorLineView.backgroundColor = UIColor.black
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        // x,y,h,w
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        // i used right anchor and it failed, Brian used width anchor
        // separatorLineView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor, constant: 0).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    // delegate method that fires off when the enter button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

