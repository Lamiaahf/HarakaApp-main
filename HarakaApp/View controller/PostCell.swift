//
//  PostCell.swift
//  HarakaApp
//
//  Created by Njood Alhajery on 15/02/2021.
//

import UIKit
import Firebase

class PostCell: UITableViewCell{
    
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
   // @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var post: Post!{
        didSet{
            updateTimeline()
        }
    }
    var likes : Bool {
         get {
            return UserDefaults.standard.bool(forKey: "likes")
         }
         set {
            UserDefaults.standard.set(newValue, forKey: "likes")
         }
    }
    
    func updateTimeline(){
//        profileImageView.image = post.createdBy.profileImage
        usernameLabel.text = post.createdBy.usernameUI
        timeAgoLabel.text = "\(post.timeAgo!)"
        captionLabel.text = post.captionUI
   //     postImageView.image = post.image
        likesLabel.text = "\(post.numOfLikesUI!)"
        commentsLabel.text = "\(post.numOfCommentsUI!)"
        
        self.likeButton.isSelected = self.likes
        
      //  self.likeButton.setTitle("0", for: .normal)
      //  self.likeButton.setTitle("1", for: .selected)
    }
    
    @IBAction func like(_ sender: Any) {
        // toggle the likes state
        self.likes = !self.likeButton.isSelected
           // set the likes button accordingly
        self.likeButton.isSelected = self.likes
    }
    
    
}
