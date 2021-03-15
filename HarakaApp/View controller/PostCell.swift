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
//    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    let ref = Database.database(url: "https://haraka-73619-default-rtdb.firebaseio.com/").reference()
    
    
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
        profileImageView.image = post.createdBy.profileImage
        usernameLabel.text = post.createdBy.usernameUI
        timeAgoLabel.text = post.timeAgo
        captionLabel.text = post.captionUI
        likesLabel.text = "\(post.numOfLikesUI!)"
        commentsLabel.text = "\(post.numOfCommentsUI!)"
        
        
        likeButton.isSelected = self.likes
 //       likeButton.setTitle("0", for: .normal)
        likesLabel.setValue("\(post.numOfLikesUI)", forKey: "likes")
        likeButton.setBackgroundImage(UIImage(named: "heart"), for: .normal)
//        likeButton.setTitle("1", for: .selected)
        likeButton.setBackgroundImage(UIImage(named:"heart.fill"), for: .selected)
    }
    
    @IBAction func like(_ sender: Any) {
        
        if(!likes){
            ref.child("PostLikes").child(self.post.postID).childByAutoId().setValue([
                "uid":String(describing: Auth.auth().currentUser?.uid)])
            
            post.numOfLikesUI = post.numOfLikesUI!+1
        }else{
            ref.child("PostLikes").child(self.post.postID).queryEqual(toValue: String(describing: Auth.auth().currentUser?.uid), childKey: "uid")
            
            //Or just let the autoid be uid and instead of uid store username
        }
        
        
        

        
     
        
    
    }
    
    
}

/*
 
 if (likeButton.imageView?.image == UIImage(named: "heart.fill")) {
        //set default
        likeButton.setImage(UIImage(named: "heart"), for: .normal)
    } else{
        // set like
        likeButton.setImage(UIImage(named: "like"), for: .normal)
    }
 
 
 // toggle the likes state
 self.likes = !self.likeButton.isSelected
 // set the likes button accordingly
 self.likeButton.isSelected = self.likes
 */
