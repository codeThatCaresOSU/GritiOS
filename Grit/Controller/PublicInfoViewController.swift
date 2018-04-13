//
//  PublicInfoViewController.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/20/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit

class PublicInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var TV: UITableView = UITableView()
    
    let list: [String] = ["Gender", "Location", "Last Name"]
    let screenSize: CGRect = UIScreen.main.bounds
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorScheme.headerColor
        self.title = "Public Info"
        
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        TV.backgroundColor = colorScheme.headerColor
        TV.tableFooterView = UIView()
        TV.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        TV.dataSource = self
        TV.delegate = self
        TV.register(PublicGenderTableViewCell.self, forCellReuseIdentifier: "genderCell")
        self.view.addSubview(TV)
        TV.register(PublicLocationTableViewCell.self, forCellReuseIdentifier: "locationCell")
        self.view.addSubview(TV)
        TV.register(PublicLastNameTableViewCell.self, forCellReuseIdentifier: "lastNameCell")
        self.view.addSubview(TV)
        
        // Remove back bar label
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellFormats.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let HeaderView = UIView()
        HeaderView.backgroundColor = colorScheme.headerColor
        let width = screenWidth - cellFormats.leftHeaderPadding
        let label = UILabel(frame: CGRect(x: cellFormats.leftHeaderPadding, y: 0, width: width, height: cellFormats.headerHeight))
        label.textAlignment = .left
        label.font = fonts.headerFont
        label.text = "Publicly Visible Information"
        HeaderView.addSubview(label)
        
        return HeaderView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let genderCell: UITableViewCell = TV.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath)
        let locationCell: UITableViewCell = TV.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        let lastNameCell: UITableViewCell = TV.dequeueReusableCell(withIdentifier: "lastNameCell", for: indexPath)
        genderCell.heightAnchor.constraint(equalToConstant: cellFormats.cellHeight).isActive = true
        genderCell.textLabel?.text = list[indexPath.row]
        locationCell.heightAnchor.constraint(equalToConstant: cellFormats.cellHeight).isActive = true
        locationCell.textLabel?.text = list[indexPath.row]
        lastNameCell.heightAnchor.constraint(equalToConstant: cellFormats.cellHeight).isActive = true
        lastNameCell.textLabel?.text = list[indexPath.row]
        
        if indexPath.row == 0 {
            return genderCell
        }
        if indexPath.row == 1 {
            return locationCell
        }
        if indexPath.row == 2 {
            return lastNameCell
        }
        return UITableViewCell()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
