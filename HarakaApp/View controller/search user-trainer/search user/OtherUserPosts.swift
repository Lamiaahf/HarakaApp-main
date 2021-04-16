//
//  OtherUserPosts.swift
//  HarakaApp
//
//  Created by lamia on 06/04/2021.
//
//other User PostCell

import UIKit
import Firebase
class OtherUserPosts: UITableViewCell {
    
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
//    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!

    let ref = Database.database().reference()
    
    
    var post: Post!{
        didSet{
            updateTimeline()
        }
    }
   
    
    func updateTimeline(){
        //profileImageView.image = post.createdBy.profileImage
        usernameLabel.text = post.createdBy.usernameUI
        timeAgoLabel.text = post.timeAgo
        captionLabel.text = post.captionUI
        likesLabel.text = "\(post.numOfLikesUI!)"
        commentsLabel.text = "\(post.numOfCommentsUI!)"
        
        
        likesLabel.text = String(post.numOfLikesUI ?? 0)
        var flag = false
        if(post.isLiked()){
             flag = true
        }
        if (!post.liked!){
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        }
        else{
            likeButton.setBackgroundImage(UIImage(systemName:"heart.fill"), for: .normal)
        }
        
    }
    
    @IBAction func openComments(_ sender: Any) {
        let controller = CommentViewController()
        controller.viewDidLoad()
        controller.setPost(post: self.post)
        controller.fetchComments()
    }
    
    @IBAction func like(_ sender: Any) {
        
        guard let id = post.postID else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        if(!post.liked!){
            ref.child("PostLikes").child(id).childByAutoId().setValue([uid:true])
            post.liked = true
            post.numOfLikesUI = post.numOfLikesUI!+1

        }else{
            ref.child("PostLikes").child(id).queryOrdered(byChild:uid).queryEqual(toValue:true).ref.removeValue()
            post.liked = false
            post.numOfLikesUI = post.numOfLikesUI!-1
        }
        updatePost()
        updateTimeline()
        }
    
    
    func updatePost(){
        ref.child("posts").child(post.postID!).updateChildValues([
                    "numOfLikes":post.numOfLikesUI!,
                    "numOfComments":post.numOfCommentsUI!])
        
    }
        
    
    
}