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
    public var usernameUI: String?
    public var profileImage: UIImage?
    
    init(u: String?, p: UIImage?) {
        usernameUI = u
        profileImage = p
    }
}


struct Trainer {
    
    var trainerID: String?
}
