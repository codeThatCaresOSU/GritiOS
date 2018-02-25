//
//  FirebaseManager.swift
//  GRIT
//
//  Created by Jared Williams on 9/24/17.
//  Copyright © 2017 CodeThatCares. All rights reserved.
//
import Foundation
import FirebaseDatabase
import FirebaseAuth


class FirebaseManager  {
    static var sharedInstance = FirebaseManager()
    private var databaseReference = Database.database().reference().child("Users")
    private var dataBaseMapReference = Database.database().reference().child("OhioData")
    private var isUserSignedIn: Bool = false
    private var currentUid: String!
    private var currentUser: User!
    
    
    func checkForExsistingUsers() {
        Auth.auth().addStateDidChangeListener { (auth, user: FirebaseAuth.User?) in
            if user != nil {
                self.isUserSignedIn = true
                self.getUserDate(firebaseUser: user!)
            }
        }
    }
    
    
    func getUserAuthStatus() -> Bool{
        return self.isUserSignedIn
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print("Error signing out")
        }
        
    }
    
    
    
    
    func createUser(user: User, completion: ((Error?) -> ())?) {
        
        Auth.auth().createUser(withEmail: user.email, password: user.password) { (firUser, error) in
            
            if error != nil {
                self.isUserSignedIn = false
                print("Error signing user up \(String(describing: error?.localizedDescription))")
            }
                
            else {
                self.isUserSignedIn = true
                self.currentUid = firUser?.uid
                user.uid = self.currentUid
                print("User Creation Success")
                self.createCustomUser(user: user)
            }
            
            completion?(error)
        }
    }
    
    func getUserDate(firebaseUser: FirebaseAuth.User) {
        self.databaseReference.child(firebaseUser.uid).observeSingleEvent(of: .value) { (data: DataSnapshot) in
            print(data)
        }
    }
    
    func createCustomUser(user: User) {
        var dictionary = Dictionary<String, String>()
        dictionary["First Name"] = user.firstName
        dictionary["Last Name"] = user.lastName
        dictionary["Age"] = user.age
        dictionary["Description"] = user.description
        self.databaseReference.child(user.uid).setValue(dictionary)
        self.currentUser = user
    }
    
    func getCurrentUser() -> User{
        return self.currentUser
    }
    
    func loginUser(email: String, password: String, completion: ((User?, Error?)->())?) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            let userReturn = User()
            
            if error == nil {
                if let firebaseUser = user {
                    
                    self.databaseReference.child(firebaseUser.uid).observe(.value) { (snapShot: DataSnapshot) in
                        if let data = snapShot.value as? [String : String]{
                            
                            userReturn.age = data["Age"]
                            userReturn.email = firebaseUser.email!
                            userReturn.firstName = data["First Name"]
                            userReturn.lastName = data["Last Name"]
                            userReturn.uid = firebaseUser.uid
                            
                            self.currentUser = userReturn
                            completion?(userReturn, error)
                        }
                    }
                }
            } else {
                completion?(nil, error)
            }
            
            
            
        }
    }
    
    func getBusinesses(flags: Array<String>, completion: @escaping (Array<Business>) -> ()) {
        
        var businesses = [Business]()
        
        dataBaseMapReference.observe(.value, with: { (snapshot: DataSnapshot) in
            
            for child in snapshot.children {
                
                let snap = child as! DataSnapshot
                
                if let data = snap.value as? [String: AnyObject] {
                    
                    let business = Business()
                    
                    business.name = data["Name"] as? String
                    business.category = data["Category"] as? String
                    business.street = data["Street Address"] as? String
                    business.city = data["City"] as? String
                    business.state = data["State"] as? String
                    business.zip = data["Zip"] as? Int
                    
                    businesses.append(business)
                    
                }
                
            }
            completion(businesses)
        })
    }
    
    
}
