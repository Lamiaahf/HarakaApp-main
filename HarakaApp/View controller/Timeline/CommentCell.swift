//
//  CommentCell.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 21/03/2021.
//

import UIKit
import Firebase

class CommentCell: UITableViewCell{
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    var observer = NSKeyValueObservation()
    
    var comment: Comment!{
        didSet{
            updateComments()
        }
    }
    
    func updateComments(){
        
        usernameLabel.text = comment.writtenBy.username
        profilePic.image = comment.writtenBy.profileImage
        commentLabel.text = comment.commentText
        
        observeChanges()
    }
    
    func observeChanges(){
        let CommentUserKeyPath = \Comment.writtenBy
        
        comment.observe(\CommentUserKeyPath, options: .new) { comment, change in
            self.usernameLabel.text = comment.writtenBy.username
            self.profilePic.image = comment.writtenBy.profileImage
        }
        
    }
    
    
    
    
}
