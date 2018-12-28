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
    var headerList: [String] = ["Options", "About"]
    var optionsList: [String] = ["Reset password", "Log out"]
    var aboutList: [String] = ["Contact us", "Developer website"]
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
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
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellFormats.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let HeaderView = UIView()
        HeaderView.backgroundColor = .black
        let width = screenWidth - cellFormats.leftHeaderPadding
        let label = UILabel(frame: CGRect(x: cellFormats.leftHeaderPadding, y: 0, width: width, height: cellFormats.headerHeight))
        label.textAlignment = .left
        label.font = fonts.headerFont
        label.textColor = Colors.niceGreen
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
            defaultCell.textLabel?.text = optionsList[indexPath.row]
        case 1:
            defaultCell.textLabel?.text = aboutList[indexPath.row]
        default:
            print("Error (cellForRowAt)")
        }
        
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!

        switch currentCell!.textLabel!.text! {
        case "Reset password":
            let alert = FirebaseManager.sharedInstance.resetPassword()
            self.present(alert, animated: true, completion: nil)
        case "Log out":
            logUserOut()
        case "Contact us":
            let contactUsVC = ContactUsViewController()
            self.navigationController?.pushViewController(contactUsVC, animated: true)
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
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
