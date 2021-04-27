//
//  Post.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import Firebase

class Post
{
    
    var createdBy: User
    var timeAgo: String?
    var timestamp: Date?
    var caption: String?
    var numOfLikes: Int?
    var numOfComments: Int?
    var UID :String?
    var postID: String?
    var liked: Bool?
    
    init(createdBy: User, timeAgo: String?, caption: String?, numOfLikes: Int?, numOfComments: Int?, postID: String?, liked: Bool?, uid : String?){
        
        self.createdBy = createdBy
        self.timeAgo = String(timeAgo![..<timeAgo!.firstIndex(of: "+")!])
        self.caption = caption
        self.numOfLikes = numOfLikes
        self.numOfComments = numOfComments
        self.postID = postID
        self.liked = liked
        self.UID = uid
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
    
    func setLiked(flag: Bool){
            liked = flag
        }
    
    init?(snapshot: DataSnapshot, user: User) {
        guard let postDict = snapshot.value as? [String : Any],
            let uid = postDict["uid"] as? String,
            let cap = postDict["caption"] as? String,
            let times = postDict["timestamp"] as? String,
            let nol = postDict["numOfLikes"] as? Int,
            let noc = postDict["numOfComments"] as? Int
            else { return nil }

        self.postID = snapshot.key
        self.UID = uid
        self.createdBy = user
        self.caption = cap
        self.timeAgo = String(times[..<times.firstIndex(of: "+")!])
        self.numOfLikes = nol
        self.numOfComments = noc
        self.liked = false
    }
    
    func isLiked() -> Bool {
        return liked!
    }

}
