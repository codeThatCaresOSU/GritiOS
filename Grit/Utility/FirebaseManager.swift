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
import FirebaseStorage


class FirebaseManager  {
    static var sharedInstance = FirebaseManager()
    private var databaseReference = Database.database().reference().child("Users")
    private var dataBaseMapReference = Database.database().reference().child("MapData").child("OhioData")
    private var isUserSignedIn: Bool = false
    private var currentUid: String!
    private var currentUser: User!
    private var storageRef = Storage.storage().reference()
    
    
    func checkForExsistingUsers(completion: ((Bool)->())?) {
        Auth.auth().addStateDidChangeListener { (auth, user: FirebaseAuth.User?) in
            if user != nil {
                self.isUserSignedIn = true
                self.getUserDate(firebaseUser: user!) {
                    completion?( user != nil )
                }
            } else {
                completion?(user != nil)
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
    
    func getUserDate(firebaseUser: FirebaseAuth.User, completion: (()->())?) {
        self.databaseReference.child(firebaseUser.uid).observeSingleEvent(of: .value) { (data: DataSnapshot) in
            
            let user = User()
            user.uid = firebaseUser.uid
            user.email = firebaseUser.email!
            print(data)
            
            if let userData = data.value as? [String : String] {
                user.age = userData["Age"]
                user.firstName = userData["First Name"]
                user.lastName = userData["Last Name"]
                self.currentUser = user
            }
            
            completion?()
        }
    }
    
    func createCustomUser(user: User) {
        var dictionary = Dictionary<String, String>()
        dictionary["First Name"] = user.firstName
        dictionary["Last Name"] = user.lastName
        dictionary["Age"] = user.age
        dictionary["Description"] = user.description
        dictionary["Occupation"] = user.occupation
        dictionary["User Typer"] = String(user.mentorStatus.rawValue)
        
        self.databaseReference.child(user.uid).setValue(dictionary)
        self.currentUser = user
    }
    
    func updateUserOccupation(newOccupation: String) {
        
        var newDictionary = Dictionary<String, String>()
        newDictionary["Occupation"] = newOccupation
        
        self.databaseReference.child("\((self.currentUser.uid)!)").updateChildValues(newDictionary)
    }
    
    func updateUserDescription(newDescription: String) {
        
        var newDictionary = Dictionary<String, String>()
        newDictionary["Description"] = newDescription
        print(self.currentUser.uid)
        print(newDictionary)
        
        self.databaseReference.child("\((self.currentUser.uid)!)").updateChildValues(newDictionary)
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
                            userReturn.description = data["Description"]
                            userReturn.occupation = data["Occupation"]
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
                    
                    business.name = data["name"] as? String
                    business.category = data["category"] as? String
                    business.street = data["address"] as? String
                    business.city = data["city"] as? String
                    business.state = data["state"] as? String
                    business.zip = data["zip"] as? String
                    business.url = data["url"] as? String
                    business.phone = data["phone"] as? String
                    
                    businesses.append(business)
                    
                }
                
            }
            completion(businesses)
        })
    }
    
    func uploadUserImageToFirebaseStorage(image: UIImage, completion: ((Error?)->())?) {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        if let uploadImage = UIImageJPEGRepresentation(image, 0.1) {
            storageRef.child("User_Profile_Images/\((self.currentUser.uid)!)").putData(uploadImage, metadata: metadata) { (_, error: Error?) in
                completion?(error)
            }
        }
    }
    
    func getProfileImageFromFirebaseStorage(completion: @escaping (UIImage) -> ()) {
        
        storageRef.child("User_Profile_Images/\((self.currentUser.uid)!)").getData(maxSize: 20 * 1024 * 1025) { (data: Data?, error: Error?) in
            
            if error != nil {
                print(error.debugDescription)
            }
            if let unwrappedData = data{
                if let image = UIImage(data: unwrappedData) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    
}
