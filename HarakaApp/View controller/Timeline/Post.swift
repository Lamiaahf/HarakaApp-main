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

    var timestamp: Date?
     var caption: String?
 //   var image: UIImage?
     var numOfLikes: Int?
     var numOfComments: Int?

    
//    var like: UIButton
 //   var comment: UIButton
     var UID :String?
     var postID: String?
     var liked: Bool?
    
    init(createdBy: User, timeAgo: String?, captionUI: String?, numOfLikesUI: Int?, numOfCommentsUI: Int?, postID: String?, liked: Bool?, uid : String?){
        
        self.createdBy = createdBy
        self.timeAgo = timeAgo
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
    
    init?(snapshot: DataSnapshot) {
        guard let postDict = snapshot.value as? [String : Any],
            let uid = postDict["uid"] as? String,
            let cap = postDict["caption"] as? String ?? "",
            let times = postDict["timestamp"] as? Date ?? Date(),
            let nol = postDict["numOfLikes"] as? Int ?? 0,
            let noc = postDict["numOfComments"] as? Int ?? 0
            else { return nil }

        self.postID = snapshot.key
        self.createdBy = User(uid)
        self.timestamp = times
        // = Date(timeIntervalSince1970: times)
    }
    
    func isLiked() -> Bool {
        return liked!
    }
    
    func setLiked(flag: Bool){
        self.liked = true
    }

}


