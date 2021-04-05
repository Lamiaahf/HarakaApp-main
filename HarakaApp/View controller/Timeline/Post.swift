//
//  Post.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit

class Post
{
     var createdBy: User
     var timeAgo: String?
     var captionUI: String?
  // var image: UIImage?
     var numOfLikesUI: Int?
     var numOfCommentsUI: Int?
    
//    var like: UIButton
 //   var comment: UIButton
     var UID :String?
     var postID: String?
     var liked: Bool?
    
    init(createdBy: User, timeAgo: String?, captionUI: String?, numOfLikesUI: Int?, numOfCommentsUI: Int?, postID: String?, liked: Bool?, uid : String?){
        self.createdBy = createdBy
        self.timeAgo = timeAgo
        self.captionUI = captionUI
        self.numOfLikesUI = numOfLikesUI
        self.numOfCommentsUI = numOfCommentsUI
        self.postID = postID
        self.liked = liked
        self.UID = uid
    }
    func isLiked() -> Bool {
        return liked!
    }
    
    func setLiked(flag: Bool){
        self.liked = true
    }

}


