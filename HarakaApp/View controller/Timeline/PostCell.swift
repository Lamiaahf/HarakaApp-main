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
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    let ref = Database.database().reference()
    
    
    var post: Post!{
        didSet{
            updateTimeline()
        }
    }
   
    override func didMoveToWindow() {
        if(post == nil){
            return
        }
        updateTimeline()
    }
    
    func updateTimeline(){

        timeAgoLabel.text = post.timeAgo
        captionLabel.text = post.caption
        likesLabel.text = "\(post.numOfLikes!)"
        commentsLabel.text = "\(post.numOfComments!)"
       // likesLabel.text = String(post.numOfLikes ?? 0)
        
        profileImageView.image = post.createdBy.profileImage
        usernameLabel.text = post.createdBy.username
        
        if (!post.liked!){
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
        else{
            likeButton.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
        }
        
        getUserPic()
    }
    func getUserPic(){
        
        DBManager.getPic(for: post.createdBy){
            pic in
            self.post.createdBy.profileImage = pic
            self.profileImageView.image = self.post.createdBy.profileImage
            self.profileImageView.layer.cornerRadius = 40/2
            self.profileImageView.clipsToBounds = true
            Utilities.CircularImageView(self.profileImageView)
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)
    }

    
    @IBAction func like(_ sender: Any) {
        
        guard let id = post.postID else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if(!post.liked!){
            ref.child("PostLikes").child(id).childByAutoId().setValue([uid:true])
            post.liked = true
            post.numOfLikes = post.numOfLikes!+1

        }else{
            ref.child("PostLikes").child(id).queryOrdered(byChild:uid).queryEqual(toValue:true).ref.removeValue()
            post.liked = false
            post.numOfLikes = post.numOfLikes!-1
        }
        updatePost()
        updateTimeline()
        }
    
    
    func updatePost(){
      //  self.likesLabel.text = "\(post.numOfLikes!)"
      //  self.commentsLabel.text = "\(post.numOfComments!)"
        ref.child("posts").child(post.postID!).updateChildValues([
                    "numOfLikes":post.numOfLikes!,
                    "numOfComments":post.numOfComments!])
        
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
