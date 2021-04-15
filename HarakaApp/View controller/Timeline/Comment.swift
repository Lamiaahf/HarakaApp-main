//
//  Comment.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 21/03/2021.
//

import UIKit
import Firebase

 class Comment{
    
    var writtenBy: User
    var commentText: String
    
    init(writtenBy: User, commentText: String){
        self.writtenBy = writtenBy
        self.commentText = commentText
    }
    
    init?(snapshot: DataSnapshot){
        guard let commentDict = snapshot.value as? [String : Any],
            let com = commentDict["comment"] as? String,
            let uid = commentDict["uid"] as? String
            else { return nil }
        self.writtenBy = User()
        self.commentText = com
        DBManager.getUser(for: uid){
            usr in
            DBManager.getPic(for: usr){
                pic in
                usr.profileImage = pic
            }
            self.writtenBy = usr
        }
    }
    
}
