//
//  MentorOptionsViewController.swift
//  SettingsPage
//
//  Created by Dave Becker on 2/19/18.
//  Copyright © 2018 Dave Becker Development. All rights reserved.
//

import UIKit
import Firebase

class MentorOptionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var TV: UITableView = UITableView()
    var optionList: [String] = ["Number of mentees", "Gender of mentees", "Public info"]
    let headerHeight: CGFloat = 60
    let leftHeaderPadding: CGFloat = 20
    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorScheme.backgroundColor
        self.title = "Mentor Options"
        TV.backgroundColor = colorScheme.headerColor
        
        TV.delegate = self
        TV.dataSource = self
        self.TV.frame = CGRect(x: 0 ,y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.TV.rowHeight = cellFormats.cellHeightMentor
        self.TV.register(MentorTableViewCell.self, forCellReuseIdentifier: "defaultCell")
        self.TV.register(GenderTableViewCell.self, forCellReuseIdentifier: "genderCell")
        self.TV.register(NumberTableViewCell.self, forCellReuseIdentifier: "numberCell")
        
        self.view.addSubview(self.TV)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Hide empty cells
        TV.tableFooterView = UIView()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath as IndexPath)
        let genderCell = tableView.dequeueReusableCell(withIdentifier: "genderCell", for: indexPath as IndexPath)
        let numberCell = tableView.dequeueReusableCell(withIdentifier: "numberCell", for: indexPath as IndexPath)
        
        // Number of mentees
        if indexPath.row == 0 {
            numberCell.textLabel?.text = optionList[indexPath.row]
            return numberCell
        }
        // Gender of mentees
        if indexPath.row == 1 {
            genderCell.textLabel?.text = optionList[indexPath.row]
            return genderCell
        }
        // Public info
        if indexPath.row == 2 {
            defaultCell.textLabel?.text = optionList[indexPath.row]
            return defaultCell
        }
        return defaultCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(optionList[indexPath.row])
        if tableView.cellForRow(at: indexPath) is MentorTableViewCell {
            let publicInfoVC = PublicInfoViewController()
            self.navigationController?.pushViewController(publicInfoVC, animated: true)
            
        }
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
