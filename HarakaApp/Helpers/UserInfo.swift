//
//  UserInfo.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 26/02/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


@objc class User: NSObject
{
    var username: String?
    var profileImageURL: String?
    var profileImage: UIImage?
    var name: String?
    var email: String?
    var followingCount: Int?
    var DOB: String?
    var userID: String?
    
    let ref: DatabaseReference = Database.database().reference()
    
    init(username: String?, profileimageurl: String?, name: String?, email: String?, followingCount: Int?, DOB: String?, id: String) {
        self.username = username
        self.profileImageURL = profileimageurl
        self.profileImage = UIImage()
        self.name = name
        self.email = email
        self.followingCount = followingCount
        self.DOB = DOB
        self.userID = id
    }
    
    init(id: String){
        super.init()
        self.userID = id
        self.getInfo(id: id)
    }
    
    override init(){
        username = ""
        profileImageURL = ""
        profileImage = UIImage()
        name = ""
        email = ""
        followingCount = -1
        DOB = ""
        userID = ""
    }
    
    init?(snapshot: DataSnapshot) {
        super.init()
        guard let userDict = snapshot.value as? [String : Any],
            let username = userDict["Username"] as? String,
            let name = userDict["Name"] as? String,
            let email = userDict["Email"] as? String,
            let fcount = userDict["followingCount"] as? Int,
            let ppURL = userDict["ProfilePic"] as? String,
            let dob = userDict["DOB"] as? Date
            else { return nil }

        self.userID = snapshot.key
        self.username = username
        self.name = name
        self.email = email
        self.followingCount = fcount
        self.profileImageURL = ppURL
        self.DOB = "\(dob)"
        
        DBManager.getPic(for: self){
            image in
            self.profileImage = image
        }
        // = Date(timeIntervalSince1970: times)
    }
    
    init?(snapshot: DataSnapshot, flag: Bool) {
        //This is called when creating a user object for the Following/Followers list, since we dont need all the information
        super.init()
        guard let userDict = snapshot.value as? [String : Any],
            let username = userDict["Username"] as? String,
            let name = userDict["Name"] as? String,
            let ppURL = userDict["ProfilePic"] as? String
            else { return nil }

        self.userID = snapshot.key
        self.username = username
        self.name = name
        self.email = ""
        self.followingCount = 0
        self.profileImageURL = ppURL
        self.DOB = ""
        
        
        DBManager.getPic(for: self){
            image in
            self.profileImage = image
        }
    }
    
     func getInfo(id: String){
  
        self.ref.child("users/\(id)").observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.exists(){
                guard let userDict = snapshot.value as? [String: Any] else {return}
                self.username = userDict["Username"] as? String
                self.name = userDict["Name"] as? String
                self.email = userDict["Email"] as? String
                self.followingCount = userDict["followingCount"] as? Int
                self.profileImageURL = userDict["ProfilePic"] as? String
                self.DOB = userDict["DOB"] as? String
                    
                self.loadPic(link: self.profileImageURL!)
            }
        })
        

    }
    
    func loadPic(link: String){
        
        Storage.storage().reference(forURL: link).getData(maxSize: 1048576, completion: { (data, error) in

            guard let imageData = data, error == nil else {
                return
            }
            self.profileImage = UIImage(data: imageData)

        })
    }
    
    
}


struct Trainer {
    
    var trainerID: String?
    var username: String?
//    var profileImageURL: String?
//    var profileImage: UIImage?
    var name: String?
    var email: String?
//    var followingCount: Int?
    var age: Int?
    
    init(username: String?,name: String?, email: String?, age: Int?) {
        self.username = username
        self.name = name
        self.email = email
        self.age = age
    }
    
    init(){
        username = ""
        name = ""
        email = ""
        age = 0
    }
}
