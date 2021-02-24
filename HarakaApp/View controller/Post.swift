//
//  Post.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import Firebase

struct Post
{
    var createdBy: User
    var timeAgo: Date?
    var captionUI: String?
 //   var image: UIImage?
    var numOfLikesUI: Int?
    var numOfCommentsUI: Int?

}

struct User
{
    var usernameUI: String?
 //   var profileImage: UIImage? 
    
}

