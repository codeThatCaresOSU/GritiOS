//
//  SettingsVC.swift
//  SettingsPage
//
//  Created by Dave Becker on 1/31/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit
import Firebase
class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var TView: UITableView = UITableView()
    var headerList: [String] = ["Options", "Account", "About"]
    var menteeOptionsList: [String] = ["Notifications"]
    var mentorOptionsList: [String] = ["Notifications", "Mentor options"]
    var optionsList: [String] = ["Notifications"]
    var accountList: [String] = ["Change password", "Log out"]
    var aboutList: [String] = ["Contact us", "Frequently asked questions", "Terms of service"]
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    var handle: UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        TView.dataSource = self
        TView.delegate = self
        TView.backgroundColor = UIColor.black
        TView.tableFooterView = UIView()
        TView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        TView.register(DefaultTableViewCell.self, forCellReuseIdentifier: "defaultCell")
        TView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "notifications")
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        self.view.addSubview(TView)
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Settings"
        
        if let user = Auth.auth().currentUser {
            /**handle = FirebaseVars.ref.child("Users").child(user.uid).observe(.value, with: { snapshot  in
                let val = snapshot.childSnapshot(forPath: "isMentor").value as! Bool
                if val {
                    self.optionsList = self.mentorOptionsList
                } else {
                    self.optionsList = self.menteeOptionsList
                }
                self.TView.reloadData()
            })**/
        } else {
            
            optionsList = menteeOptionsList
            TView.reloadData()
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let user = Auth.auth().currentUser {
           // FirebaseVars.ref.child("Users").child(user.uid).removeObserver(withHandle: handle)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellFormats.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let HeaderView = UIView()
        HeaderView.backgroundColor = Colors.niceGreen
        let width = screenWidth - cellFormats.leftHeaderPadding
        let label = UILabel(frame: CGRect(x: cellFormats.leftHeaderPadding, y: 0, width: width, height: cellFormats.headerHeight))
        label.textAlignment = .left
        label.font = fonts.headerFont
        label.text = headerList[section]
        HeaderView.addSubview(label)
        
        return HeaderView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var numRows = 0
        
        switch section {
        case 0:
            numRows = optionsList.count
        case 1:
            numRows = accountList.count
        case 2:
            numRows = aboutList.count
        default:
            return 0
        }
        return numRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let defaultCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        defaultCell.heightAnchor.constraint(equalToConstant: cellFormats.cellHeight).isActive = true
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0{
                let notiCell = tableView.dequeueReusableCell(withIdentifier: "notifications", for: indexPath) as! NotificationsTableViewCell
                notiCell.textLabel?.text = mentorOptionsList[indexPath.row]
                notiCell.heightAnchor.constraint(equalToConstant: cellFormats.cellHeight).isActive = true
                return notiCell
            }
            defaultCell.textLabel?.text = optionsList[indexPath.row]
        case 1:
            defaultCell.textLabel?.text = accountList[indexPath.row]
        case 2:
            defaultCell.textLabel?.text = aboutList[indexPath.row]
        default:
            print("Error (cellForRowAt)")
        }
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!
        
        // Check label of cell and change to respective VC
        switch currentCell!.textLabel!.text! {
        case "Mentor options":
            let mentorVC = MentorOptionsViewController()
            self.navigationController?.pushViewController(mentorVC, animated: true)
        case "Change password":
            let changePasswordVC = ChangePasswordViewController()
            self.navigationController?.pushViewController(changePasswordVC, animated: true)
        case "Log out":
            logUserOut()
        case "Contact us":
            let contactUsVC = ContactUsViewController()
            self.navigationController?.pushViewController(contactUsVC, animated: true)
        case "Frequently asked questions":
            let faqVC = FAQViewController()
            self.navigationController?.pushViewController(faqVC, animated: true)
        case "Terms of service":
            let tosVC = TermsOfServiceViewController()
            self.navigationController?.pushViewController(tosVC, animated: true)
        default:
            print("Error selecting row")
        }
    }
    
    func logUserOut() {
        
        let firebaseAuth = Auth.auth()
        let alert = UIAlertController()
        print("Logging user out")
        do {
            try firebaseAuth.signOut()
            alert.title = "Success!"
            alert.message = "You have been successfully logged out."
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            alert.title = "Error!"
            alert.message = "We were unable to log you out."
        }
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {(alert: UIAlertAction!) in
            self.optionsList = self.menteeOptionsList
            self.TView.reloadData()
            self.title = "Guest"
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}
