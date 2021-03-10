//
//  UserInfo.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 26/02/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

let cUser = Auth.auth().currentUser
let ref = Database.database().reference()

struct currentUser{
    
    let cuEmail = cUser?.email
    let cuID = cUser?.uid
    let cuURL = URL(string: ref.child("users").value(forKey: "ProfilePic") as! String)
    let cuImage = UIImage(named:"figure.walk.circle")
}


struct User
{
    var usernameUI: String?
    var profileImage: UIImage?
    
}
