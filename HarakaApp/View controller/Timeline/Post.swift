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
     var caption: String?
 //   var image: UIImage?
     var numOfLikes: Int?
     var numOfComments: Int?
    
//    var like: UIButton
 //   var comment: UIButton
    
     var postID: String?
    var liked: Bool?
    
    
    init(createdBy: User, timeAgo: String?, caption: String?, numOfLikes: Int?, numOfComments: Int?, postID: String?, liked: Bool?){
        self.createdBy = createdBy
        self.timeAgo = timeAgo
        self.caption = caption
        self.numOfLikes = numOfLikes
        self.numOfComments = numOfComments
        self.postID = postID
        self.liked = liked
    }
    
    init(){
        createdBy = User()
        timeAgo = ""
        caption = ""
        numOfLikes = 0
        numOfComments = 0
        postID = ""
        liked = false
    }
    
    func isLiked() -> Bool {
        return liked!
    }
    
    func setLiked(flag: Bool){
        self.liked = true
    }

}


