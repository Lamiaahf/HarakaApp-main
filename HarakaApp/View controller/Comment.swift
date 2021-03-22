//
//  Comment.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 21/03/2021.
//

import UIKit

class Comment{
    
    var writtenBy: User
    var commentText: String?
    
    init(writtenBy: User, commentText: String?){
        self.writtenBy = writtenBy
        self.commentText = commentText
    }
    
    
}
