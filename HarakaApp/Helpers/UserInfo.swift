//
//  UserInfo.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 26/02/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


struct User
{
    var username: String?
    var profileImageURL: String?
    var profileImage: UIImage?
    var name: String?
    var email: String?
    var followingCount: Int?
    var DOB: String?
    var userID: String?
    
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
    init(){
        username = ""
        profileImageURL = ""
        profileImage = UIImage()
        name = ""
        email = ""
        followingCount = -1
        DOB = ""
        userID = ""
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
